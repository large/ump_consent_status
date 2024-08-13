/// Possible returns for consents
/// -----------------------------
///
/// all = App should be able to show personalized ads for all configured vendors
///
/// nonPersonalized =  App should be able to show at most non-personalized ads as defined by Google
///
/// limited = App should be able to show at most limited ads as defined by Google
///
/// unclear = Display of any ads is unclear, mostly due to a problem with figuring out which vendors were properly configured
///
/// none = No ads will be shown due to lacking consent or legitimate interest

enum AdConfig
{
  all,
  nonPersonalized,
  limited,
  unclear,
  none,
}
