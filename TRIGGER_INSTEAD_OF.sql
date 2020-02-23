create or replace view animal_with_stripes as
SELECT
    animal_name,
    (
    SELECT stripe_color FROM (
        SELECT stripe_color,
            rank() over (partition by ANIMAL_ID order by animal_stripe_id) stripe_rank
        FROM animal_stripe
        where animal.ANIMAL_ID = ANIMAL_STRIPE.ANIMAL_ID
        )
    where stripe_rank = 1
    ) stripe_one,
    (
    SELECT stripe_color FROM (
        SELECT stripe_color,
            rank() over (partition by ANIMAL_ID order by animal_stripe_id) stripe_rank
        FROM animal_stripe
        where animal.ANIMAL_ID = ANIMAL_STRIPE.ANIMAL_ID
        )
    where stripe_rank = 2
    ) stripe_two
FROM animal;

insert into animal_with_stripes
values('Zebra 3', 'Red', 'Yellow');

rollback;

SELECT * FROM animal_with_stripes;

create or replace trigger trg_animal_with_stripes_ins
instead of insert on animal_with_stripes
declare
    l_animal_id int;
begin
    l_animal_id := seq_animal_id.nextval;

    insert into animal(animal_id, animal_name)
    values(l_animal_id, :new.animal_name);
    
    insert into animal_stripe(animal_id, stripe_color)
    values(l_animal_id, :new.stripe_one);
    
    insert into animal_stripe(animal_id, stripe_color)
    values(l_animal_id, :new.stripe_two);
end;


create or replace trigger trg_animal_with_stripes_upd
instead of update on animal_with_stripes
declare
    l_animal_id int;
begin
    select animal_id
    into l_animal_id
    from animal
    where animal_name = :new.animal_name;
    
    update animal_stripe
    set stripe_color = :new.stripe_one
    where animal_id = l_animal_id and stripe_color = :old.stripe_one;

    update animal_stripe
    set stripe_color = :new.stripe_two
    where animal_id = l_animal_id and stripe_color = :old.stripe_two;
end;

update animal_with_stripes
set stripe_one = 'Grey', stripe_two = 'Orange'
where animal_name = 'Zebra 3';


create or replace trigger trg_animal_with_stripes_del
instead of delete on animal_with_stripes
declare
    l_animal_id int;
begin
    select animal_id
    into l_animal_id
    from animal
    where animal_name = :old.animal_name;
    
    dbms_output.put_line(l_animal_id);
    
    delete from animal_stripe where animal_id = l_animal_id;
    dbms_output.put_line('animal_stripe ' || sql%rowcount);
    delete from animal where animal_id = l_animal_id;
    dbms_output.put_line('animal ' || sql%rowcount);
end;

delete from animal_with_stripes
where animal_name = 'Zebra 3';

