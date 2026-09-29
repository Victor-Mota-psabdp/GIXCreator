SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from doc_anexos
--select * from Caixa_Hou_Exp_Aer where num_proc_hea = 'EAATL201301001BR'

--select * from Caixa_Hou_Exp_Aer where num_lcto = 'LA2013011324'

CREATE Procedure [dbo].[spEnvioReciboAereo_Sel]--'LA2013011324'		
	@Lcto	VarChar(16)
AS

	select 
		CEA.Num_Proc_HEA JOB, 
		Apelido CredDeb 
	from Caixa_Hou_Exp_Aer CEA
		join house_exp_aer HEA on HEA.num_proc_hea = CEA.num_proc_hea	
		join campo_pessoa CP on CP.cd_pes = HEA.cd_export_hea
		join pessoa P on P.cd_pes = CP.cd_pes
	where
		Num_Lcto = @Lcto
		and HEA.num_proc_mea <> 'JOB'
		and CEA.dc_hea = 'C'
		and CP.campo_dados = '1' and id_campo = 8
		and CEA.cd_tp_tx not like 'X%'

	UNION

	select 
		CEA.Num_Proc_HIA JOB, 
		Apelido CredDeb 
	from Caixa_Hou_Imp_Aer CEA
		join house_imp_aer HEA on HEA.num_proc_hia = CEA.num_proc_hia	
		join campo_pessoa CP on CP.cd_pes = HEA.cd_consig_hia
		join pessoa P on P.cd_pes = CP.cd_pes
	where
		Num_Lcto = @Lcto 
		and HEA.num_proc_mia <> 'JOB'
		and CEA.dc_hia = 'C'
		and CP.campo_dados = '1' and id_campo = 8
		and CEA.cd_tp_tx not like 'X%'

	order by 1






GO
