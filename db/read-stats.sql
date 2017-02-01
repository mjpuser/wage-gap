.load ../extension-functions.so

drop table women_stats;
create table women_stats(
  total int,
  avg_salary int,
  min_salary int,
  max_salary int,
  occupation_id text
);

insert into women_stats (
  total,
  avg_salary,
  min_salary,
  max_salary,
  occupation_id
)
select
  count(*),
  median(c.salary),
  -- avg(c.salary),
  min(c.salary),
  max(c.salary),
  c.occupation
from
  census c
where
  c.hours in (40, 41)
  and c.age >= 30
  and c.age < 40
  -- and c.age >= 20
  -- and c.age < 30
  and c.weeks in (1, 2)
  and c.education >= 21
  and c.sex = 2
  and c.marital_status = 0
  and c.salary > 12000
group by
  c.sex, c.occupation;


drop table men_stats;
create table men_stats(
  total int,
  avg_salary int,
  min_salary int,
  max_salary int,
  occupation_id text
);

insert into men_stats (
  total,
  avg_salary,
  min_salary,
  max_salary,
  occupation_id
)
select
  count(*),
  median(c.salary),
  -- avg(c.salary),
  min(c.salary),
  max(c.salary),
  c.occupation
from
  census c
where
c.hours in (40, 41)
 and c.age >= 30
 and c.age < 40
  -- and c.age >= 20
  -- and c.age < 30
  and c.weeks in (1, 2)
  and c.education >= 21
  and c.sex = 1
  and c.marital_status = 0
  and c.salary > 12000
group by
  c.sex, c.occupation;

.width -11 -9 -15 -15 -15 -15 -15 -15 -15 80
.mode csv
select
  ws.total as `# of women`,
  ms.total as `# of men`,
  printf('%.2f', ms.avg_salary * 1.0 / ws.avg_salary) as percentage,
  printf('%.2f', ws.avg_salary) as `women's median`,
  printf('%.2f', ms.avg_salary) as `men's median`,
  ws.max_salary as `women's max`,
  ms.max_salary as `men's max`,
  ws.min_salary as `women's minimum`,
  ms.min_salary as `men's minimum`,
  o.name as occupation
from
  men_stats ms,
  women_stats ws,
  occupation o
where
  ms.occupation_id = ws.occupation_id
  and o.id = ms.occupation_id
  and ws.avg_salary > ms.avg_salary
  and ws.total >= 30
  and ms.total >= 30
order by
  ms.avg_salary * 1.0 / ws.avg_salary, o.name;

select
  ws.total as `# of women`,
  ms.total as `# of men`,
  printf('%.2f', ws.avg_salary * 1.0 / ms.avg_salary) as percentage,
  printf('%.2f', ws.avg_salary) as `women's median`,
  printf('%.2f', ms.avg_salary) as `men's median`,
  ws.max_salary as `women's max`,
  ms.max_salary as `men's max`,
  ws.min_salary as `women's minimum`,
  ms.min_salary as `men's minimum`,
  o.name as occupation
from
  men_stats ms,
  women_stats ws,
  occupation o
where
  ms.occupation_id = ws.occupation_id
  and o.id = ms.occupation_id
  and ws.avg_salary < ms.avg_salary
  and ws.total >= 30
  and ms.total >= 30
order by
  ws.avg_salary * 1.0 / ms.avg_salary, o.name;


select
  ws.total as `# of women`,
  ms.total as `# of men`,
  printf('%.2f', ms.avg_salary * 1.0 / ws.avg_salary) as percentage,
  printf('%.2f', ws.avg_salary) as `women's median`,
  printf('%.2f', ms.avg_salary) as `men's median`,
  ws.max_salary as `women's max`,
  ms.max_salary as `men's max`,
  ws.min_salary as `women's minimum`,
  ms.min_salary as `men's minimum`,
  o.name as occupation
from
  men_stats ms,
  women_stats ws,
  occupation o
where
  ms.occupation_id = ws.occupation_id
  and o.id = ms.occupation_id
  and ws.avg_salary = ms.avg_salary
  and ws.total >= 30
  and ms.total >= 30
order by
  ws.avg_salary * 1.0 / ms.avg_salary, o.name;

vacuum;
