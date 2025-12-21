@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suppl Projection View'
@Metadata.allowExtensions: true
define view entity ZC_BOOKINGSUPPL_STR
  as projection on ZI_BOOKSUPPL_STR
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'SupplemenDesc' ]
      SupplementId,
      _Supplement_Text.Description as SupplemenDesc : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Travel  : redirected to ZC_TRAVEL_STR,
      _Booking : redirected to parent ZC_BOOKING_STR,
      _Supplement,
      _Supplement_Text
}
