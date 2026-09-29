SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spHBL_EM_Container_Sel]--'EMATL201205019BR'
	@Processo	varchar(16)
As
	Select		
		Num_cont_EM,		
		VOL.Peso_Bruto_EM,
		MAS.Peso_Liquido_EM,
		Num_lacre_EM,
		TCC.Nome_Tp_Carga,
		--Dt_Vcto_Devol_EM,
		--Dt_Devol_EM,
		VolumeM3,
		Nome_Tp_cont ,
		--NG.Descr					Packages_GOODS,
		--HOU.Obs_HEM					Marks_Numbers,
		--HOU.Peso_Bruto_HEM			Gross_Weight,
		--HOU.Peso_Liquido_HEM		Net_Weight,
		--convert(varchar(10),LLP.Dt_Impres_LEM,103) Dated_At,
		[dbo].[Qty_Container](@processo) qtde,
		qtd_vol_em			qty,
		nome_tp_embal		nomeEmbal,
		Tara_EM,
		
		Marca_EM,
		Contra_Marca
		
		
	from 
		container_mas_exp_mar MAS
		Left Outer Join Tipo_Container TC on TC.cd_tp_cont=MAS.cd_tp_cont
		Left Outer Join Container_Hou_exp_Mar CHOU on MAS.Num_Proc_MeM = CHOU.Num_Proc_MeM and MAS.Item_Cont_EM = CHOU.Item_Cont_EM   
--		left outer join house_exp_mar HOU on HOU.num_proc_HeM = CHOU.Num_Proc_HeM
		Left Outer Join LLP_exp_mar LLP on CHOU.Num_Proc_HeM = LLP.Num_Proc_LeM
		Left Outer Join Tipo_Carga TCC on LLP.Cd_Tp_Carga = TCC.Cd_Tp_Carga and TCC.Ativo_TP = 'S'
		left outer join volume_exp_mar Vol on VOL.num_proc_HeM = CHOU.Num_Proc_HeM and MAS.Item_Cont_EM = VOL.Item_Cont_EM
		Left Outer Join Tipo_Embalagem TE on VOL.Cd_Tp_embal = TE.Cd_Tp_embal
	   
	where
		CHou.num_proc_hem=@processo
	order by 1

GO
