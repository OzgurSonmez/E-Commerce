create or replace noneditionable type changePassword_type as object
(
       emailAddress VARCHAR2(255),
       current_password VARCHAR2(255),
       new_password VARCHAR2(255)
)
/
