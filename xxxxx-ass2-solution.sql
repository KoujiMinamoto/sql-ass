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

  -- diner 1
  insert
  into
    diner values
    (
      1,0,2,
      to_date('03-MAY-2017 11:31:15 PM','dd-Mon-yyyy hh:mi:ss PM'),
      null,
      1
    );

  insert
  into
    fs_diner values
    (
      1,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Arancini Balls'
      )
      ,
      'ST',
      2,
      'O'
    );
    
  insert
  into
    fs_diner values
    (
      1,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Braised Beef Brisket'
      )
      ,
      'SM',
      2,
      'O'
    );
    
  insert
  into
    fs_diner values
    (
      1,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Corona Beer'
      )
      ,
      'ST',
      2,
      'O'
    );

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 1
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Arancini Balls'
    )
  and food_serve_size = 'ST';

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 1
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Braised Beef Brisket'
    )
  and food_serve_size = 'SM';

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 1
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Corona Beer'
    )
  and food_serve_size = 'ST';

  update
    diner
  set
    diner_payment_due =
    (
      select
        sum(food_serve_cost*fs_diner_no_serves)
      from
        food_serve s
      join fs_diner f
      on
        s.food_item_no      = f.food_item_no
      and s.food_serve_size = f.food_serve_size
      where
        diner_no = 1
    )
  where
    diner_no = 1;

  update
    diner
  set
    diner_completed = to_date('03-MAY-2017 1:03:45 PM',
    'dd-Mon-yyyy hh:mi:ss PM')
  where
    diner_no = 1;
  commit;

  -- diner 2
  insert
  into
    diner values
    (
      4,0,1,
      to_date('08-MAY-2017 1:19:30 PM','dd-Mon-yyyy hh:mi:ss PM'),
      null,
      1
    );

  insert
  into
    fs_diner values
    (
      4,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Beef Carpaccio'
      )
      ,
      'ST',
      1,
      'O'
    );
  insert
  into
    fs_diner values
    (
     4,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Bruschetta'
      )
      ,
      'ST',
      2,
      'O'
    );

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 4
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Beef Carpaccio'
    )
  and food_serve_size = 'ST';

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 4
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Bruschetta'
    )
  and food_serve_size = 'ST';

  update
    diner
  set
    diner_payment_due =
    (
      select
        sum(food_serve_cost*fs_diner_no_serves)
      from
        food_serve s
      join fs_diner f
      on
        s.food_item_no      = f.food_item_no
      and s.food_serve_size = f.food_serve_size
      where
        diner_no = 4
    )
  where
    diner_no = 4;

  update
    diner
  set
    diner_completed = to_date('08-MAY-2017 2:35:32 PM',
    'dd-Mon-yyyy hh:mi:ss PM')
  where
    diner_no = 4;
  commit;

  -- diner 3
  insert
  into
    diner values
    (
      6,0,1,
      to_date('11-MAY-2017 10:30:17 AM','dd-Mon-yyyy hh:mi:ss PM'),
      null,
      1
    );

  insert
  into
    fs_diner values
    (
      6,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Ravioli Ricotta'
      )
      ,
      'SM',
      1,
      'O'
    );
  insert
  into
    fs_diner values
    (
      6,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Classic Chocolate Mousse'
      )
      ,
      'ST',
      2,
      'O'
    );
  insert
  into
    fs_diner values
    (
      6,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Braised Beef Brisket'
      )
      ,
      'LG',
      1,
      'O'
    );

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 6
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Ravioli Ricotta'
    )
  and food_serve_size = 'SM';

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 6
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Classic Chocolate Mousse'
    )
  and food_serve_size = 'ST';

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 6
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Braised Beef Brisket'
    )
  and food_serve_size = 'LG';

  update
    diner
  set
    diner_payment_due =
    (
      select
        sum(food_serve_cost*fs_diner_no_serves)
      from
        food_serve s
      join fs_diner f
      on
        s.food_item_no      = f.food_item_no
      and s.food_serve_size = f.food_serve_size
      where
        diner_no = 6
    )
  where
    diner_no = 6;

  update
    diner
  set
    diner_completed = to_date('11-MAY-2017 12:05:00 PM',
    'dd-Mon-yyyy hh:mi:ss PM')
  where
    diner_no = 6;
  commit;

  -- diner 4
  insert
  into
    diner values
    (
      7,0,2,
      to_date('12-MAY-2017 11:57:00 AM','dd-Mon-yyyy hh:mi:ss PM'),
      null,
      1
    );

  insert
  into
    fs_diner values
    (
      7,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Braised Beef Brisket'
      )
      ,
      'ST',
      3,
      'O'
    );
    
  insert
  into
    fs_diner values
    (
      7,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Spaghetti Marinara'
      )
      ,
      'ST',
      1,
      'O'
    );
    
  insert
  into
    fs_diner values
    (
      7,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'House White (Glass)'
      )
      ,
      'ST',
      4,
      'O'
    );

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 7
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Braised Beef Brisket'
    )
  and food_serve_size = 'ST';

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 7
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Spaghetti Marinara'
    )
  and food_serve_size = 'ST';

  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 7
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'House White (Glass)'
    )
  and food_serve_size = 'ST';

  update
    diner
  set
    diner_payment_due =
    (
      select
        sum(food_serve_cost*fs_diner_no_serves)
      from
        food_serve s
      join fs_diner f
      on
        s.food_item_no      = f.food_item_no
      and s.food_serve_size = f.food_serve_size
      where
        diner_no = 7
    )
  where
    diner_no = 7;

  update
    diner
  set
    diner_completed = to_date('12-MAY-2017 1:40:24 PM',
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
      'Tloves',
      'Coffee-flavoured dessert',
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
      1784,12
    );
  commit;




  -- Task 3.2
  -- Monash food has decided to increase the price charged for all standard
  -- serve
  -- ('ST') main food items ('M' food type) by 15%, make this change in the
  -- database

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



  -- Task 3.3 (b) This new diner calls the waiter over and proceeds to order
  -- two 'Bruschetta'
  -- entrees. Entrees are only available in a standard 'ST' size. Add this data
  -- to the
  -- Monash Food System for this diner. The food item has not been served as
  -- yet, this is
  -- an order only

  insert
  into
    fs_diner values
    (
      diner_diner_no_seq.currval,
      (
        select
          food_item_no
        from
          fooditem
        where
          food_name = 'Bruschetta'
      )
      ,
      'ST',
      2,
      'O'
    );
  commit;

  
  -- Task 3.3 (c) Some time after this order has been recorded the 'Bruschetta'
  -- are served to
  -- this diner - update the database to record this service.


  update
    fs_diner
  set
    fs_diner_item_served = 'S'
  where
    diner_no       = 10
  and food_item_no =
    (
      select
        food_item_no
      from
        fooditem
      where
        food_name = 'Bruschetta'
    )
  and food_serve_size = 'ST';

  update
  diner
  set
  diner_payment_due =
  (
      select
      sum(food_serve_cost*fs_diner_no_serves)
      from
      food_serve s
      join fs_diner f
      on
      s.food_item_no  = f.food_item_no
      and s.food_serve_size = f.food_serve_size
      where
      diner_no = 10
    )
  where
  diner_no = 10;
  commit;

 
  -- Task 4 Database Structure
  -- =========================
  -- Task 4.1 Collection of Diner information

  create
    table diner_record
    (
      diner_id          number(8) not null,
      name                  varchar(50) not null,
      contact_mobile_number number(10),
      email_address         varchar(50),
      receive_special_event char(1) not null  //receive_special_event这个名字要改一下！是用来确定用餐者到底接不接收广告。
    );

  alter table diner_record add constraint chk_receive_special_event check (
  receive_special_event in ( 'Y','N' ) );  //同上这个名字也要改一下！

  alter table diner_record add constraint diner_record_pk primary key (diner_id
  );

create sequence diner_record_diner_id_seq start with 1 increment by 1;

  alter table diner add diner_id number(8);

  alter table diner add constraint diner_diner_record_fk foreign key (
  diner_id) references diner_record (diner_id) not deferrable;

  commit;


  -- Task 4.2 End of financial year DINER and FS_DINER archive

  create
    table diner_history as
    (
      select
        diner_no,
        diner_payment_due,
        diner_seated,
        diner_completed,
        diner_id
      from
        diner
      where
        diner_completed >= to_date('01-July-2016','dd-Mon-yyyy')
      and 
        diner_completed < to_date('01-July-2017','dd-Mon-yyyy')
    );

  alter table diner_history add constraint diner_history_pk primary key (
  diner_no);

  alter table diner_history add constraint diner_history_diner_record_fk foreign
  key (diner_id) references diner_record (diner_id) not deferrable;

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
        diner_completed >= to_date('01-July-2016','dd-Mon-yyyy')
      and 
        diner_completed < to_date('01-July-2017','dd-Mon-yyyy')
    );

  alter table fs_diner_history add constraint fs_diner_history_pk primary key (
  diner_no,food_item_no,food_serve_size);

  alter table fs_diner_history add constraint fs_diner_history_diner_history_fk foreign key (
    diner_no) 
  references diner_history (diner_no) not deferrable;
                                           //fs_diner_history_diner_history_fk这个名字过长了 你自己改

  alter table fs_diner_history add constraint fs_diner_history_food_serve_fk
  foreign key (food_item_no,food_serve_size) references food_serve (
  food_item_no,food_serve_size) not deferrable;

  delete
  from
    fs_diner
  where
    diner_no in (select diner_no
  from 
    diner
  where 
    diner_completed >= to_date('01-July-2016','dd-Mon-yyyy')
  and diner_completed < to_date('01-July-2017','dd-Mon-yyyy'));

  delete
  from
    diner
  where
    diner_completed >= to_date('01-July-2016','dd-Mon-yyyy')
  and diner_completed < to_date('01-July-2017','dd-Mon-yyyy');

  commit;

  --========================= END OF ASS2-SOLUTION.SQL ========================
  -- ==========
