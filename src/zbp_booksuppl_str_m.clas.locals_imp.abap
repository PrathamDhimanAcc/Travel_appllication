CLASS lhc_zi_booksuppl_str DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_booksuppl_str~calculateTotalPrice.

ENDCLASS.

CLASS lhc_zi_booksuppl_str IMPLEMENTATION.

  METHOD calculateTotalPrice.

    DATA: it_travel TYPE STANDARD TABLE OF zi_travel_str_m WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    it_travel = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelId = TravelId  ).

    MODIFY ENTITIES OF zi_travel_str_m IN LOCAL MODE
             ENTITY zi_travel_str_m
             EXECUTE reCalcTotPrice
             FROM CORRESPONDING #( it_travel ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
