drop table census_import;
create table census_import (
  age INT,
  education INT,
  sex INT,
  salary INT,
  hours INT,
  weeks INT,
  occupation1 Text,
  occupation2 Text,
  marital_status INT
);

drop table census;
create table census (
  age INT,
  education INT,
  sex INT,
  salary INT,
  hours INT,
  weeks INT,
  occupation Text,
  marital_status INT
);

drop table occupation;
create table occupation (
  id Text,
  name Text
);

.mode csv

.import ../data/agg-census-data.csv census_import
.import ../occupation-mapping-10.csv occupation

insert into census(
  age,
  education,
  sex,
  salary,
  hours,
  weeks,
  occupation,
  marital_status
) select
  age,
  education,
  sex,
  salary,
  hours,
  weeks,
  case
    when census_import.occupation1 = 'N.A.' then
      census_import.occupation2
    when census_import.occupation2 = 'N.A.' then
      census_import.occupation1
    else
      coalesce(census_import.occupation1, census_import.occupation2)
  end,
  marital_status
from census_import;

update census
set salary = null
where salary = '';

update census
set hours = null
where hours = '';

update census
set weeks = null
where weeks = '';

update census
set occupation = null
where occupation = '';

update census
set education = null
where education = '';

update census
set marital_status = null
where marital_status = '';

delete from census where salary = 0 or salary is null;

-- removing bad data.  This is illegal if you are paying minimum wage
-- delete from census where salary < 10000 and weeks in (1, 2);

drop table census_import;
vacuum;
