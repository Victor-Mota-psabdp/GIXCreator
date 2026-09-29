SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spHBL_EM_Volume_Sel]--'EMATL201608009BR'
	@Processo	varchar(16)			
AS

	Select distinct
		--Item_EM,
		Qtd_Vol_EM,
		Nome_Tp_Embal,
		HOU.Peso_Bruto_EM,
		MAS.Peso_Liquido_EM,
		--Compr_EM,
		--Largura_EM,
		--Altura_EM,		
		--NCM,
		Marca_EM,
		Contra_Marca,
		--dbo.fNCM(@Processo) NCM_RPT,
		MAS.Num_Cont_EM Container,	
		mas.Num_Lacre_EM,		
		Tara_EM,
		TCC.Nome_Tp_Carga
	From
		Volume_EXP_Mar	HOU
		Join Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
		--Join NCM N on N.Id_NCM = HOU.Id_NCM
		Left Join Container_Hou_exp_Mar CH on HOU.Num_Proc_HEM = CH.Num_Proc_HEM and HOU.Item_Cont_EM = CH.Item_Cont_EM   
		LEFT Join Container_Mas_exp_Mar MAS on MAS.Num_Proc_MEM = CH.Num_Proc_MEM and MAS.Item_Cont_EM = CH.Item_Cont_EM   
		Left Outer Join LLP_exp_mar LLP on CH.Num_Proc_HeM = LLP.Num_Proc_LeM
		Left Outer Join Tipo_Carga TCC on LLP.Cd_Tp_Carga = TCC.Cd_Tp_Carga and TCC.Ativo_TP = 'S'
	Where
		HOU.num_proc_HEM=@Processo
--	order by
--		Item_EM




GO
