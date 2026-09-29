SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spOrigFwReference] 

as

select Num_Proc_Lio Job,ETD_Lio ETD,PP.Apelido Consignee,SH.Apelido Shipper,Tipo_Lio Modal from llp_imp_out
Join House_Imp_out hou on hou.num_proc_hio=num_proc_lio
Join Pessoa pp on pp.cd_pes=cd_consig_hio
Join Pessoa SH on SH.cd_pes=cd_export_hio
Where etd_lio > '09-01-2008'
and 
intl_ref_lio is  null

Union

select Num_Proc_Lim,ETD_Lim,pp.Apelido Consignee,SH.Apelido Shipper,'M' from llp_imp_mar
Join House_Imp_mar hou on hou.num_proc_him=num_proc_lim

Join Pessoa pp on pp.cd_pes=cd_consig_him
Join Pessoa SH on SH.cd_pes=cd_export_him
Join Localidade Org on ORG.cd_local=cd_planta_lim
Where etd_lim > '09-01-2008'
and 
intl_ref_lim is  null and cd_pais='AR'


GO
