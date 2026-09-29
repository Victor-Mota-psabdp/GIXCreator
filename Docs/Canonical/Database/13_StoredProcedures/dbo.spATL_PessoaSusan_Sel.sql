SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_PessoaSusan_Sel 'ALL'
CREATE procedure [dbo].[spATL_PessoaSusan_Sel]
(
 @Grupo varchar(10)
)
as
select distinct
'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Exporter'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)]
from vwHouse_Exp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Export = PS.cd_pes
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Exporter' [TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)] from vwHouse_Imp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Export = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 
'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Consig) [CLIENT CODE ],
'Consignee'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)]
from vwHouse_Exp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Consig) [CLIENT CODE ],
'Consignee'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)] from vwHouse_Imp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct
'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Notify) [CLIENT CODE ],
'Notify'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)]
from vwHouse_Exp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Notify = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Import) [CLIENT CODE ],
'Notify'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)] from vwHouse_Imp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Import = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all

select distinct
'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Notify) [CLIENT CODE ],
'ShipTo'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)]
from vwHouse_Exp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Import) [CLIENT CODE ],
'ShipTo'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)] from vwHouse_Imp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct
'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Notify) [CLIENT CODE ],
'SoldTo'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)]
from vwHouse_Exp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Import) [CLIENT CODE ],
'SoldTo'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)] from vwHouse_Imp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct
'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Importer'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)]
from vwHouse_Exp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Importer' [TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)] from vwHouse_Imp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct
'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Buyer'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)]
from vwHouse_Exp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Buyer' [TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)] from vwHouse_Imp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Consig = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct
'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Seller'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)]
from vwHouse_Exp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Export = PS.cd_pes
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Seller' [TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)] from vwHouse_Imp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Export = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct
'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Supplier'[TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)]
from vwHouse_Exp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Export = PS.cd_pes
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'
union all
select distinct 'ATL' [SYSTEM NAME],
UPPER(HOU.Cd_Export) [CLIENT CODE ],
'Supplier' [TABLE CODE], 
UPPER(PS.Nome_Raz_Soc) [ENTITY NAME],
UPPER(COM.Rua+ ' ' + Isnull(COM.numero,'') + ' ' + Isnull(COM.Compl_end,'')) [ADDRESS LINE 1],
NULL [ADDRESS LINE 2],
NULL [ADDRESS LINE 3],
NULL [ADDRESS LINE 4],
NULL [ADDRESS LINE 5],
NULL [ADDRESS LINE 6],
UPPER(COM.Cidade) [CITY NAME],
COM.CEP [POSTAL CODE],
UPPER(COM.UF) [STATE PROVINCE CODE],
UPPER(COM.CD_pais) [COUNTRY CODE],
PS.GLOBAL_ENTITY_ID [GEID (Global Entity ID)] from vwHouse_Imp HOU with(nolock)
Join Pessoa PS with(nolock) on  HOU.Cd_Export = PS.cd_pes and PS.Desat_Pes = 'N'
left join Endereco COM with(nolock) on PS.Cd_Pes = COM.Cd_Pes and COM.Cd_Tp_End = 'COM'
where hou.Dt_Emis >= '2013-01-01'

order by 2
option(hash join) 



GO
