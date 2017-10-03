/*
FIT9132 2017 Semester 2 Assignment 2 SOLUTIONS SCRIPT
Student Name:
Student ID:
Studio Class:
Tutor:
Comments for your marker:
*/


-- Task 1 Data Definition
-- ======================

-- Task 1.1
create
  table fs_diner
  (
    diner_no             number(8) not null,
    food_item_no         number(4) not null,
    food_serve_size      char(2 byte) not null,
    fs_diner_no_serves   number(1) not null,
    fs_diner_item_served char(1) not null
  );

alter table fs_diner add constraint chk_fs_diner_item_served check (
fs_diner_item_served in ( 'O','S' ) );

comment on column fs_diner.diner_no
is
  'Diner identifier';

  comment on column fs_diner.food_item_no
is
  'Identifier for a particular menu item';

  comment on column fs_diner.food_serve_size
is
  'Food serve size - must be SM,ST or LG';

  comment on column fs_diner.fs_diner_no_serves
is
  'The number of serves diners have ordered';

  comment on column fs_diner.fs_diner_item_served
is
  'O to indicate this is an order, S to indicate the order has been served';

  alter table fs_diner add constraint fs_diner_pk primary key ( diner_no,
  food_item_no,food_serve_size );

  alter table fs_diner add constraint fs_diner_diner_fk foreign key ( diner_no
  ) references diner ( diner_no ) not deferrable;

  alter table fs_diner add constraint fs_diner_food_serve_fk foreign key (
  food_item_no,food_serve_size ) references food_serve ( food_item_no,
  food_serve_size ) not deferrable;
  commit;


  -- Task 1.2
  -- drop table statements
  -- here you must NOT use CASCADE constraints

  drop
    table fs_diner;
  drop
    table beverage;
  drop
    table entree;
  drop
    table main;
  drop
    table dessert;
  drop
    table diner;
  drop
    table table_details;
  drop
    table food_serve;
  drop
    table fooditem;
  commit;

  -- Task 2 Data Manipulation
  -- ========================

  -- Task 2.1
  -- Add to your database four DINER records and their associated FS_DINER
  -- records

  select
    *
  from
    diner
  order by
    diner_no;

  select
    *
  from
    fs_diner
  order by
    diner_no,
    fs_diner_no_serves;

  -- diner 1
  select
    i.food_item_no,
    i.food_name,
    food_serve_size,
    food_serve_cost
  from
    fooditem i
  join food_serve s
  on
    i.food_item_no = s.food_item_no
  where
    food_name  = 'Bruschetta'
  or food_name = 'Braised Beef Brisket'
  order by
    food_item_no;

  insert
  into
    diner values
    (
      1,0,3,
      to_date('07-MAY-2017 12:33:05 PM','dd-Mon-yyyy hh:mi:ss PM'),
      null,
      1
    );

  insert
  into
    fs_diner values
    (
      1,1,
      'ST',
      1,
      'O'
    );
  insert
  into
    fs_diner values
    (
      1,4,
      'ST',
      2,
      'O'
    );

  select
    sum(food_serve_cost*fs_diner_no_serves)
  from
    (
      select
        i.food_item_no,
        i.food_name,
        f.food_serve_size,
        food_serve_cost,
        f.fs_diner_no_serves
      from
        fooditem i
      join food_serve s
      on
        i.food_item_no = s.food_item_no
      join fs_diner f
      on
        s.food_item_no      = f.food_item_no
      and s.food_serve_size = f.food_serve_size
      join diner d
      on
        d.diner_no = f.diner_no
      where
        (
          f.food_serve_size = 'ST'
        and f.diner_no      = 1
        and i.food_name     = 'Bruschetta'
        )
      or
        (
          f.food_serve_size = 'ST'
        and f.diner_no      = 1
        and i.food_name     = 'Braised Beef Brisket'
        )
      order by
        food_item_no
    );

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 1
  and food_item_no       = 1
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 1;

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 1
  and food_item_no       = 4
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 2;

  update
    diner
  set
    diner_payment_due =
    (
      select
        sum(food_serve_cost*fs_diner_no_serves)
      from
        (
          select
            i.food_item_no,
            i.food_name,
            f.food_serve_size,
            food_serve_cost,
            f.fs_diner_no_serves
          from
            fooditem i
          join food_serve s
          on
            i.food_item_no = s.food_item_no
          join fs_diner f
          on
            s.food_item_no      = f.food_item_no
          and s.food_serve_size = f.food_serve_size
          join diner d
          on
            d.diner_no = f.diner_no
          where
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 1
            and i.food_name     = 'Bruschetta'
            )
          or
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 1
            and i.food_name     = 'Braised Beef Brisket'
            )
          order by
            food_item_no
        )
    )
    ,
    diner_completed = to_date('07-MAY-2017 1:05:45 PM',
    'dd-Mon-yyyy hh:mi:ss PM')
  where
    diner_no = 1;

  -- diner 2
  insert
  into
    diner values
    (
      3,0,1,
      to_date('07-MAY-2017 1:12:27 PM','dd-Mon-yyyy hh:mi:ss PM'),
      null,
      1
    );

  select
    i.food_item_no,
    i.food_name,
    food_serve_size,
    food_serve_cost
  from
    fooditem i
  join food_serve s
  on
    i.food_item_no = s.food_item_no
  where
    food_name  = 'Arancini Balls'
  or food_name = 'Beef Carpaccio'
  order by
    food_item_no;

  insert
  into
    fs_diner values
    (
      3,2,
      'ST',
      1,
      'O'
    );
  insert
  into
    fs_diner values
    (
      3,3,
      'ST',
      1,
      'O'
    );

  select
    sum(food_serve_cost*fs_diner_no_serves)
  from
    (
      select
        i.food_item_no,
        i.food_name,
        f.food_serve_size,
        food_serve_cost,
        f.fs_diner_no_serves
      from
        fooditem i
      join food_serve s
      on
        i.food_item_no = s.food_item_no
      join fs_diner f
      on
        s.food_item_no      = f.food_item_no
      and s.food_serve_size = f.food_serve_size
      join diner d
      on
        d.diner_no = f.diner_no
      where
        (
          f.food_serve_size = 'ST'
        and f.diner_no      = 3
        and i.food_name     = 'Arancini Balls'
        )
      or
        (
          f.food_serve_size = 'ST'
        and f.diner_no      = 3
        and i.food_name     = 'Beef Carpaccio'
        )
      order by
        food_item_no
    );

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 3
  and food_item_no       = 2
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 1;

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 3
  and food_item_no       = 3
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 1;

  update
    diner
  set
    diner_payment_due =
    (
      select
        sum(food_serve_cost*fs_diner_no_serves)
      from
        (
          select
            i.food_item_no,
            i.food_name,
            f.food_serve_size,
            food_serve_cost,
            f.fs_diner_no_serves
          from
            fooditem i
          join food_serve s
          on
            i.food_item_no = s.food_item_no
          join fs_diner f
          on
            s.food_item_no      = f.food_item_no
          and s.food_serve_size = f.food_serve_size
          join diner d
          on
            d.diner_no = f.diner_no
          where
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 3
            and i.food_name     = 'Arancini Balls'
            )
          or
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 3
            and i.food_name     = 'Beef Carpaccio'
            )
          order by
            food_item_no
        )
    )
    ,
    diner_completed = to_date('07-MAY-2017 1:55:42 PM',
    'dd-Mon-yyyy hh:mi:ss PM')
  where
    diner_no = 3;

  -- diner 3
  insert
  into
    diner values
    (
      4,0,3,
      to_date('09-MAY-2017 10:27:07 AM','dd-Mon-yyyy hh:mi:ss PM'),
      null,
      1
    );

  select
    i.food_item_no,
    i.food_name,
    food_serve_size,
    food_serve_cost
  from
    fooditem i
  join food_serve s
  on
    i.food_item_no = s.food_item_no
  where
    food_name  = 'Sticky Date Pudding'
  or food_name = 'Ravioli Ricotta'
  or food_name = 'House White (Glass)'
  order by
    food_item_no;

  insert
  into
    fs_diner values
    (
      4,5,
      'SM',
      1,
      'O'
    );
  insert
  into
    fs_diner values
    (
      4,7,
      'ST',
      1,
      'O'
    );
  insert
  into
    fs_diner values
    (
      4,9,
      'ST',
      1,
      'O'
    );

  select
    sum(food_serve_cost*fs_diner_no_serves)
  from
    (
      select
        i.food_item_no,
        i.food_name,
        f.food_serve_size,
        food_serve_cost,
        f.fs_diner_no_serves
      from
        fooditem i
      join food_serve s
      on
        i.food_item_no = s.food_item_no
      join fs_diner f
      on
        s.food_item_no      = f.food_item_no
      and s.food_serve_size = f.food_serve_size
      join diner d
      on
        d.diner_no = f.diner_no
      where
        (
          f.food_serve_size = 'ST'
        and f.diner_no      = 4
        and i.food_name     = 'Sticky Date Pudding'
        )
      or
        (
          f.food_serve_size = 'SM'
        and f.diner_no      = 4
        and i.food_name     = 'Ravioli Ricotta'
        )
      or
        (
          f.food_serve_size = 'ST'
        and f.diner_no      = 4
        and i.food_name     = 'House White (Glass)'
        )
      order by
        food_item_no
    );

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 4
  and food_item_no       = 7
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 1;

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 4
  and food_item_no       = 9
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 1;

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 4
  and food_item_no       = 5
  and food_serve_size    = 'SM'
  and fs_diner_no_serves = 1;

  update
    diner
  set
    diner_payment_due =
    (
      select
        sum(food_serve_cost*fs_diner_no_serves)
      from
        (
          select
            i.food_item_no,
            i.food_name,
            f.food_serve_size,
            food_serve_cost,
            f.fs_diner_no_serves
          from
            fooditem i
          join food_serve s
          on
            i.food_item_no = s.food_item_no
          join fs_diner f
          on
            s.food_item_no      = f.food_item_no
          and s.food_serve_size = f.food_serve_size
          join diner d
          on
            d.diner_no = f.diner_no
          where
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 4
            and i.food_name     = 'Sticky Date Pudding'
            )
          or
            (
              f.food_serve_size = 'SM'
            and f.diner_no      = 4
            and i.food_name     = 'Ravioli Ricotta'
            )
          or
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 4
            and i.food_name     = 'House White (Glass)'
            )
          order by
            food_item_no
        )
    )
    ,
    diner_completed = to_date('09-MAY-2017 12:01:04 PM',
    'dd-Mon-yyyy hh:mi:ss PM')
  where
    diner_no = 4;

  -- diner 4
  insert
  into
    diner values
    (
      7,0,2,
      to_date('11-MAY-2017 11:07:05 AM','dd-Mon-yyyy hh:mi:ss PM'),
      null,
      1
    );

  select
    i.food_item_no,
    i.food_name,
    food_serve_size,
    food_serve_cost
  from
    fooditem i
  join food_serve s
  on
    i.food_item_no = s.food_item_no
  where
    food_name  = 'Braised Beef Brisket'
  or food_name = 'Corona Beer'
  or food_name = 'Arancini Balls'
  or food_name = 'Classic Chocolate Mousse'
  order by
    food_item_no;

  insert
  into
    fs_diner values
    (
      7,4,
      'LG',
      1,
      'O'
    );
  insert
  into
    fs_diner values
    (
      7,10,
      'ST',
      1,
      'O'
    );
  insert
  into
    fs_diner values
    (
      7,2,
      'ST',
      2,
      'O'
    );
  insert
  into
    fs_diner values
    (
      7,8,
      'ST',
      3,
      'O'
    );

  select
    sum(food_serve_cost*fs_diner_no_serves)
  from
    (
      select
        i.food_item_no,
        i.food_name,
        f.food_serve_size,
        food_serve_cost,
        f.fs_diner_no_serves
      from
        fooditem i
      join food_serve s
      on
        i.food_item_no = s.food_item_no
      join fs_diner f
      on
        s.food_item_no      = f.food_item_no
      and s.food_serve_size = f.food_serve_size
      join diner d
      on
        d.diner_no = f.diner_no
      where
        (
          f.food_serve_size = 'LG'
        and f.diner_no      = 7
        and i.food_name     = 'Braised Beef Brisket'
        )
      or
        (
          f.food_serve_size = 'ST'
        and f.diner_no      = 7
        and i.food_name     = 'Corona Beer'
        )
      or
        (
          f.food_serve_size = 'ST'
        and f.diner_no      = 7
        and i.food_name     = 'Arancini Balls'
        )
      or
        (
          f.food_serve_size = 'ST'
        and f.diner_no      = 7
        and i.food_name     = 'Classic Chocolate Mousse'
        )
      order by
        food_item_no
    );

  select
    *
  from
    fs_diner;

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 7
  and food_item_no       = 4
  and food_serve_size    = 'LG'
  and fs_diner_no_serves = 1;

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 7
  and food_item_no       = 10
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 1;

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 7
  and food_item_no       = 2
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 2;

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 7
  and food_item_no       = 8
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 3;

  update
    diner
  set
    diner_payment_due =
    (
      select
        sum(food_serve_cost*fs_diner_no_serves)
      from
        (
          select
            i.food_item_no,
            i.food_name,
            f.food_serve_size,
            food_serve_cost,
            f.fs_diner_no_serves
          from
            fooditem i
          join food_serve s
          on
            i.food_item_no = s.food_item_no
          join fs_diner f
          on
            s.food_item_no      = f.food_item_no
          and s.food_serve_size = f.food_serve_size
          join diner d
          on
            d.diner_no = f.diner_no
          where
            (
              f.food_serve_size = 'LG'
            and f.diner_no      = 7
            and i.food_name     = 'Braised Beef Brisket'
            )
          or
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 7
            and i.food_name     = 'Corona Beer'
            )
          or
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 7
            and i.food_name     = 'Arancini Balls'
            )
          or
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 7
            and i.food_name     = 'Classic Chocolate Mousse'
            )
          order by
            food_item_no
        )
    )
    ,
    diner_completed = to_date('11-MAY-2017 1:02:52 PM',
    'dd-Mon-yyyy hh:mi:ss PM')
  where
    diner_no = 7;
  commit;

  -- Task 2.2
  -- Provide the create sequence commands to be used for primary key vales when
  -- adding
  -- food items and diners to the system.
  -- - the food item sequence should start at 11 and increment by 1
  -- - the diner sequence should start at 10 and increment by 1

create sequence fooditem_food_item_no_seq start with 11 increment by 1;
create sequence diner_diner_no_seq start with 10 increment by 1;
  commit;

  -- Task 2.3
  --  Provide the drop sequence statements for the two sequences you created in
  -- Q2.1

  drop
    sequence fooditem_food_item_no_seq;
  drop
    sequence diner_diner_no_seq;
  commit;

  -- Task 3 Database Insert/Updates
  -- ==============================

  -- SEQUENCES created in task 2.2 must be used in this task for the adding
  -- primary keys.

  -- Task 3.1
  --  Add a new DESSERT to the Monash food menu - you will need to research
  -- some
  -- meaningful data to be able to add this item.  DESSERT's are food_type 'D'
  -- and are
  -- only served in standard 'ST' serve sizes.

  insert
  into
    fooditem values
    (
      fooditem_food_item_no_seq.nextval,
      'Tiramisu',
      'Coffee-flavoured italian cuisine custard dessert',
      'D'
    );
  insert
  into
    dessert values
    (
      fooditem_food_item_no_seq.currval,
      'N'
    );
  insert
  into
    food_serve values
    (
      fooditem_food_item_no_seq.currval,
      'ST',
      2059,15
    );
  commit;

  select
    *
  from
    fooditem;
  select
    *
  from
    dessert;
  select
    *
  from
    food_serve;


  -- Task 3.2
  -- Monash food has decided to increase the price charged for all standard
  -- serve
  -- ('ST') main food items ('M' food type) by 15%, make this change in the
  -- database

  select
    food_serve_cost
  from
    fooditem i
  join food_serve s
  on
    i.food_item_no = s.food_item_no
  join main
  on
    i.food_item_no = main.food_item_no
  where
    s.food_serve_size = 'ST'
  and i.food_type     = 'M';

  select
    *
  from
    food_serve;

  update
    food_serve
  set
    food_serve_cost = food_serve_cost*1.15
  where
    food_serve_size = 'ST'
  and food_item_no in
    (
      select
        food_item_no
      from
        fooditem
      where
        food_type = 'M'
    );
  commit;


  -- Task 3.3 Diner Activity

  -- Task 3.3 (a) A new diner has just arrived and been seated at Table 1 seat
  -- 3. Update the
  -- database to seat this diner

  insert
  into
    diner values
    (
      diner_diner_no_seq.nextval,
      0,3,
      to_date(sysdate,'dd-Mon-yyyy hh:mi:ss PM'),
      null,
      1
    );
  commit;

  select
    *
  from
    diner;

  -- Task 3.3 (b) This new diner calls the waiter over and proceeds to order
  -- two 'Bruschetta'
  -- entrees. Entrees are only available in a standard 'ST' size. Add this data
  -- to the
  -- Monash Food System for this diner. The food item has not been served as
  -- yet, this is
  -- an order only

  select
    i.food_item_no,
    i.food_name,
    food_serve_size,
    food_serve_cost
  from
    fooditem i
  join food_serve s
  on
    i.food_item_no = s.food_item_no
  where
    food_name         = 'Bruschetta'
  and food_serve_size = 'ST'
  order by
    food_item_no;

  insert
  into
    fs_diner values
    (
      diner_diner_no_seq.currval,
      1,
      'ST',
      2,
      'O'
    );
  commit;

  select
    *
  from
    fs_diner;

  -- Task 3.3 (c) Some time after this order has been recorded the 'Bruschetta'
  -- are served to
  -- this diner - update the database to record this service.

  select
    diner_diner_no_seq.currval
  from
    dual;
  select
    to_char(sysdate,'dd-Mon-yyyy hh:mi:ss PM')
  from
    dual;
  select
    sysdate
  from
    dual;

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no             = 10
  and food_item_no       = 1
  and food_serve_size    = 'ST'
  and fs_diner_no_serves = 2;

  update
    diner
  set
    diner_payment_due =
    (
      select
        sum(food_serve_cost*fs_diner_no_serves)
      from
        (
          select
            i.food_item_no,
            i.food_name,
            f.food_serve_size,
            food_serve_cost,
            f.fs_diner_no_serves
          from
            fooditem i
          join food_serve s
          on
            i.food_item_no = s.food_item_no
          join fs_diner f
          on
            s.food_item_no      = f.food_item_no
          and s.food_serve_size = f.food_serve_size
          join diner d
          on
            d.diner_no = f.diner_no
          where
            (
              f.food_serve_size = 'ST'
            and f.diner_no      = 10
            and i.food_name     = 'Bruschetta'
            )
          order by
            food_item_no
        )
    )
  where
    diner_no = 10;
  commit;

  select
    *
  from
    fs_diner;

  select
    *
  from
    diner;

  -- Task 4 Database Structure
  -- =========================
  -- Task 4.1 Collection of Diner information

  create
    table diner_info
    (
      diner_inf_no          number(8) not null,
      name                  varchar(50) not null,
      contact_mobile_number number(10),
      email_address         varchar(50),
      receive_special_event char(1) not null
    );

  alter table diner_info add constraint chk_receive_special_event check (
  receive_special_event in ( 'Y','N' ) );

  alter table diner_info add constraint diner_info_pk primary key (diner_inf_no
  );

create sequence diner_info_diner_inf_no_seq start with 1 increment by 1;

  alter table diner add diner_inf_no number(8);

  alter table diner add constraint diner_diner_info_fk foreign key (
  diner_inf_no) references diner_info (diner_inf_no) not deferrable;

  commit;

  select
    *
  from
    diner_info;

  select
    *
  from
    diner;

  -- Task 4.2 End of financial year DINER and FS_DINER archive
  -- Task 4.2 End of financial year DINER and FS_DINER archive

  select
    diner_no,
    diner_payment_due,
    diner_seated,
    diner_completed,
    diner_inf_no
  from
    diner
  where
    diner_completed < to_date('01-July-2017','dd-Mon-yyyy');

  select
    f.diner_no,
    food_item_no,
    food_serve_size,
    fs_diner_no_serves,
    fs_diner_item_served
  from
    fs_diner f
  join diner d
  on
    f.diner_no = d.diner_no
  where
    diner_completed < to_date('01-July-2017','dd-Mon-yyyy');

  create
    table diner_history as
    (
      select
        diner_no,
        diner_payment_due,
        diner_seated,
        diner_completed,
        diner_inf_no
      from
        diner
      where
        diner_completed < to_date('01-July-2017','dd-Mon-yyyy')
    );

  alter table diner_history add constraint diner_history_pk primary key (
  diner_no);

  alter table diner_history add constraint diner_history_diner_info_fk foreign
  key (diner_inf_no) references diner_info (diner_inf_no) not deferrable;

  create
    table fs_diner_history as
    (
      select
        f.diner_no,
        food_item_no,
        food_serve_size,
        fs_diner_no_serves,
        fs_diner_item_served
      from
        fs_diner f
      join diner d
      on
        f.diner_no = d.diner_no
      where
        diner_completed < to_date('01-July-2017','dd-Mon-yyyy')
    );

  alter table fs_diner_history add constraint fs_diner_history_pk primary key (
  diner_no,food_item_no,food_serve_size);

  alter table fs_diner_history add constraint history_fs_diner_diner_fk foreign
  key (diner_no) -- fs_diner_history_diner_history_pk
  references diner_history (diner_no) not deferrable;

  alter table fs_diner_history add constraint fs_diner_history_food_serve_fk
  foreign key (food_item_no,food_serve_size) references food_serve (
  food_item_no,food_serve_size) not deferrable;

  delete
  from
    fs_diner
  where
    diner_no  = 1
  or diner_no = 3
  or diner_no = 4
  or diner_no = 7;

  delete
  from
    diner
  where
    diner_no  = 1
  or diner_no = 3
  or diner_no = 4
  or diner_no = 7;

  select
    *
  from
    diner_history;

  select
    *
  from
    diner;

  select
    *
  from
    fs_diner_history;

  select
    *
  from
    fs_diner;

  commit;

  --========================= END OF ASS2-SOLUTION.SQL ========================
  -- ==========
