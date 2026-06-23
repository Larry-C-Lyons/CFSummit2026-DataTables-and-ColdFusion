ALTER TABLE employees
  ADD FULLTEXT INDEX ft_employees (name, position, office);

CREATE INDEX ix_emp_name_id      ON employees (name, employee_id);
CREATE INDEX ix_emp_pos_id       ON employees (position, employee_id);
CREATE INDEX ix_emp_office_id    ON employees (office, employee_id);
CREATE INDEX ix_emp_start_id     ON employees (start_date, employee_id);
CREATE INDEX ix_emp_salary_id    ON employees (salary, employee_id);
CREATE INDEX ix_emp_extn_id      ON employees (extn, employee_id);