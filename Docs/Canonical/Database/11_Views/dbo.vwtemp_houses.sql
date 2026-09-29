SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view vwtemp_houses
as
select cd_export_hea cd_pes from house_exp_aer
union
select cd_import_hia from house_imp_aer
union
select cd_import_him from house_imp_mar
union
select cd_export_hem from house_exp_mar


GO
