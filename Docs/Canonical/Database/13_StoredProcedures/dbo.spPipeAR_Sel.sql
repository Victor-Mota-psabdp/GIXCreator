SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spPipeAR_Sel

as


Select 
	distinct excprocesso  Processo
From 
	House_Exp_Mar
	Join Localidade DST on DST.cd_local=cd_dst_hem
	Join Exchange EXC on EXC.excprocesso=num_proc_hem
where 
	cd_pais = 'AR' and ExcDataAlt >=getdate()-60 
	and ExcDtRetorno is null

Union All


Select 
	distinct excprocesso 
From 
	House_Exp_Aer
	Join Localidade DST on DST.cd_local=cd_dst_hea
	Join Exchange EXC on EXC.excprocesso=num_proc_hea
where 
	cd_pais = 'AR' and ExcDataAlt >=getdate()-60 
	and ExcDtRetorno is null


Union All

Select 
	distinct excprocesso 
From 
	House_Exp_Out
	Join Localidade DST on DST.cd_local=cd_dst_heo
	Join Exchange EXC on EXC.excprocesso=num_proc_heo
where 
	cd_pais = 'AR' and ExcDataAlt >=getdate()-60 
	and ExcDtRetorno is null

Union All

Select 
	distinct excprocesso 
From 
	House_Imp_Mar
	Join Localidade DST on DST.cd_local=cd_org_him
	Join Exchange EXC on EXC.excprocesso=num_proc_him
where 
	cd_pais = 'AR' and ExcDataAlt >=getdate()-60 
	and ExcDtRetorno is null


Union all

Select 
	distinct excprocesso 
From 
	House_Imp_Aer
	Join Localidade DST on DST.cd_local=cd_org_hia
	Join Exchange EXC on EXC.excprocesso=num_proc_hia
where 
	cd_pais = 'AR' and ExcDataAlt >=getdate()-60 
	and ExcDtRetorno is null

Union all

Select 
	distinct excprocesso 
From 
	House_Imp_Out
	Join Localidade DST on DST.cd_local=cd_org_hio
	Join Exchange EXC on EXC.excprocesso=num_proc_hio
where 
	cd_pais = 'AR' and ExcDataAlt >=getdate()-60 
	and ExcDtRetorno is null

GO
