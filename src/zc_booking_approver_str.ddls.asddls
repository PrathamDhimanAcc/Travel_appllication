@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Approver Projection'
@UI.headerInfo: { typeName: 'Booking',
                  typeNamePlural: 'Bookings',

                  title:{ type: #STANDARD,
                  label: 'Booking',
                  value: 'BookingId' } }
@Search.searchable: true
//@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_BOOKING_APPROVER_STR
  as projection on ZI_BOOKING_STR_M
{
      @UI.facet: [{ id:'Travel' ,
                      purpose: #STANDARD,
                      position: 10,
                      label: 'Booking',
                      type: #IDENTIFICATION_REFERENCE }]
      @Search.defaultSearchElement: true
  key TravelId,
      @UI: { lineItem: [{ position: 20, importance: #HIGH }],
         identification: [{ position: 20 }]}
      @Search.defaultSearchElement: true
  key BookingId,
      @UI: { lineItem: [{ position: 30, importance: #HIGH }],
             identification: [{ position: 30 }]}
      BookingDate,
      @UI: { lineItem: [{ position: 40, importance: #HIGH }],
            identification: [{ position: 40 }],
            selectionField: [{ position: 10 }]}
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName         as CustomerName,
      @UI: { lineItem: [{ position: 50, importance: #HIGH }],
            identification: [{ position: 50 }]}
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _Carrier.Name              as CarrierName,
      @UI: { lineItem: [{ position: 60, importance: #HIGH }],
            identification: [{ position: 60 }]}
      ConnectionId,
      @UI: { lineItem: [{ position: 70, importance: #HIGH }],
           identification: [{ position: 70 }]}
      FlightDate,
      @UI: { lineItem: [{ position: 80, importance: #HIGH }],
           identification: [{ position: 80 }]}
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @UI: { lineItem: [{ position: 90 }],
      identification: [{ position: 00, label: 'Status' }],
      textArrangement: #TEXT_ONLY }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {  name: '/DMO/I_Booking_Status_VH', element: 'BookingStatus' } }]
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      _Booking_Status._Text.Text as BookingStatusText : localized,
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _Bookingsuppl,
      _Booking_Status,
      _Carrier,
      _Connection,
      _Customer,
      _Travel : redirected to parent ZC_TRAVEL_APPROVER_STR
}
