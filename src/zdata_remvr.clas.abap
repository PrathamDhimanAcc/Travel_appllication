CLASS zdata_remvr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zdata_remvr IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zlog_travel_str.

    COMMIT ENTITIES.

    out->write( | Deleted these much { sy-dbcnt } entries from the database table. | ).

    DELETE FROM ztravel_str_d_m.

    DELETE FROM ztravel_str_m.
    DELETE FROM zbooksupp_str_m.

    DELETE FROM zbooking_str_d_m.

    DELETE FROM zbksup_d_m.

    DELETE FROM zbooking_str_m.
  ENDMETHOD.
ENDCLASS.
