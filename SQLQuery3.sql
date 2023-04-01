CREATE TABLE [ROLE] (
  [ROLE_ID] int NOT NULL UNIQUE primary key,
  [ROLE_TITLE] VARCHAR(50) NOT NULL,
  [ROLE_DESCRIPTION] VARCHAR(200)
);

CREATE TABLE [EMPLOYEE] (
  [EMP_ID] int NOT NULL unique Primary key,
  [EMP_NAME] varchar(50) not null,
  [EMP_ADDRESS] varchar(100) not null,
  [EMP_DOB] date not null,
  [EMP_GENDER] char(1) not null,
  [EMP_HIRE_DATE] date not null,
  [EMP_FIRE_DATE] date,
  [EMP_DEPART_DATE] date,
  [EMP_LOCKER] int check (EMP_LOCKER >= 1),
  [EMP_PAY_RATE] float not null check (EMP_PAY_RATE >= 15.65),
  [EMP_VACATION_ENTITLEMENT] int not null check (EMP_VACATION_ENTITLEMENT >= 0),
  [EMP_SICK_DAYS_ENTITLEMENT] int not null check (EMP_SICK_DAYS_ENTITLEMENT >= 0),
  [DEP_ID] int NOT NULL foreign key references DEPARTMENT.DEP_ID,
  [ROLE_ID] int NOT NULL check (ROLE_ID >= 1 and ROLE_ID <= 5) foreign key references ROLE.ROLE_ID
);

CREATE TABLE [SCHEDULE] (
  [SCH_ID] int not null unique primary key,
  [SCH_DATE] date not null,
  [EMP_ID] int not null foreign key references EMPLOYEE.EMP_ID
);

CREATE TABLE [DEPARTMENT_HISTORY] (
  [HST_ID] int not null unique primary key,
  [HST_START_DATE] date not null,
  [HST_END_DATE] date,
  [EMP_ID] int not null foreign key references EMPLOYEE.EMP_ID,
  [DEP_ID] int not null foreign key references DEPARTMENT.DEP_ID,
  [ROLE_ID] int not null foreign key references ROLE.ROLE_ID
);

CREATE TABLE [CERTIFICATION] (
  [CERT_ID] int not null unique primary key,
  [CERT_NAME] varchar(50) not null,
  [CERT_VALID_FOR] date not null,
  [ORG_NAME] varchar(50) not null
);

CREATE TABLE [ROLE_CERT] (
  [CERT_ID] int not null primary key foreign key references CERTIFICATION.CERT_ID,
  [ROLE_ID] int not null primary key foreign key references ROLE.ROLE_ID,
  --PRIMARY KEY ([CERT_ID], [ROLE_ID]),
  CONSTRAINT [FK_ROLE_CERT.ROLE_ID]
    FOREIGN KEY ([ROLE_ID])
      REFERENCES [CERTIFICATION]([CERT_ID]),
  CONSTRAINT [FK_ROLE_CERT.CERT_ID]
    FOREIGN KEY ([CERT_ID])
      REFERENCES [EMPLOYEE_ROLE]([ROLE_ID])
);

CREATE INDEX [FK2] ON  [ROLE_CERT] ([CERT_ID]);

CREATE INDEX [FK1] ON  [ROLE_CERT] ([ROLE_ID]);

CREATE TABLE [SKILL] (
  [SKILL_ID] <type>,
  [SKILL_NAME] <type>,
  [IS_VALID] <type>,
  PRIMARY KEY ([SKILL_ID])
);

CREATE TABLE [INTERNAL_SESSION] (
  [TRAIN_ID] <type>,
  [SKILL_ID] <type>,
  [EMP_DELIVERER] <type>,
  PRIMARY KEY ([TRAIN_ID]),
  CONSTRAINT [FK_INTERNAL_SESSION.TRAIN_ID]
    FOREIGN KEY ([TRAIN_ID])
      REFERENCES [SKILL]([IS_VALID])
);

CREATE TABLE [SECTION_SKILL] (
  [SEC_ID] <type>,
  [SKILL_ID] <type>,
  PRIMARY KEY ([SEC_ID], [SKILL_ID])
);

CREATE TABLE [EMP_EXTERNAL_TRAINING] (
  [TRAIN_ID] <type>,
  [EMP_ID] <type>,
  [IS_SUCCESSFUL] <type>,
  PRIMARY KEY ([TRAIN_ID], [EMP_ID])
);

CREATE INDEX [FK1] ON  [EMP_EXTERNAL_TRAINING] ([TRAIN_ID]);

CREATE INDEX [FK2] ON  [EMP_EXTERNAL_TRAINING] ([EMP_ID]);

CREATE TABLE [INVENTORY_SHIFT] (
  [INV_ID] <type>,
  [SHIFT_ID] <type>,
  PRIMARY KEY ([INV_ID], [SHIFT_ID])
);

CREATE TABLE [EXTERNAL_SESSION] (
  [TRAIN_ID] <type>,
  [CERT_ID] <type>,
  PRIMARY KEY ([TRAIN_ID]),
  CONSTRAINT [FK_EXTERNAL_SESSION.TRAIN_ID]
    FOREIGN KEY ([TRAIN_ID])
      REFERENCES [CERTIFICATION]([CERT_NAME])
);

CREATE TABLE [SHIFT] (
  [SHIFT_ID] <type>,
  [SHIFT_TYPE] <type>,
  [SHIFT_START] <type>,
  [SHIFT_END] <type>,
  [SCH_ID] <type>,
  [EMP_ID] <type>,
  [COVER_ID] <type>,
  [SEC_ID] <type>,
  PRIMARY KEY ([SHIFT_ID]),
  CONSTRAINT [FK_SHIFT.SHIFT_END]
    FOREIGN KEY ([SHIFT_END])
      REFERENCES [EMPLOYEE]([EMP_SICK_DAYS_ENTITLEMENT]),
  CONSTRAINT [FK_SHIFT.SHIFT_TYPE]
    FOREIGN KEY ([SHIFT_TYPE])
      REFERENCES [EMPLOYEE]([EMP_VACATION_ENTITLEMENT])
);

CREATE TABLE [SECTION] (
  [SEC_ID] <type>,
  [SEC_NAME] <type>,
  PRIMARY KEY ([SEC_ID])
);

CREATE TABLE [EMP_INTERNAL_TRAINING] (
  [TRAIN_ID] <type>,
  [EMP_ID] <type>,
  [IS_SUCCESSFUL] <type>,
  PRIMARY KEY ([TRAIN_ID], [EMP_ID])
);

CREATE INDEX [FK1] ON  [EMP_INTERNAL_TRAINING] ([TRAIN_ID]);

CREATE INDEX [FK2] ON  [EMP_INTERNAL_TRAINING] ([EMP_ID]);

CREATE TABLE [DEPARTMENT] (
  [DEP_ID] <type>,
  [DEP_NAME] <type>,
  [HEAD_EMP_ID] <type>,
  PRIMARY KEY ([DEP_ID])
);

CREATE TABLE [LEAVE] (
  [LEAVE_ID] <type>,
  [LEAVE_TYPE] <type>,
  [LEAVE_START] <type>,
  [LEAVE_END] <type>,
  [EMP_ID] <type>,
  PRIMARY KEY ([LEAVE_ID])
);

CREATE TABLE [INVENTORY] (
  [INV_ID] <type>,
  [INV_TITLE] <type>,
  [INV_PRICE] <type>,
  [INV_QTY] <type>,
  PRIMARY KEY ([INV_ID])
);

CREATE TABLE [WRITTEN_WARNING] (
  [WW_ID] <type>,
  [WW_DATE] <type>,
  [WW_LEVEL] <type>,
  [WW_STATUS] <type>,
  [WW_COMMENTS] <type>,
  [EMP_ID] <type>,
  [ISSUER_ID] <type>,
  PRIMARY KEY ([WW_ID])
);

CREATE TABLE [TRAINING_SESSION] (
  [TRAIN_ID] <type>,
  [TRAIN_TYPE] <type>,
  [TRAIN_DATE] <type>,
  PRIMARY KEY ([TRAIN_ID])
);
