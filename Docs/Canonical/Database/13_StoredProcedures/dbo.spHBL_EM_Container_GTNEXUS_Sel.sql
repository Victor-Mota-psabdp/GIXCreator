SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spHBL_EM_Container_GTNEXUS_Sel]'EMARG201604066AR'
CREATE PROCEDURE [dbo].[spHBL_EM_Container_GTNEXUS_Sel]
	@Processo	varchar(16)
As
	Select	
		CHOU.Num_proc_hem					,
		Num_cont_EM,		
		Num_lacre_EM,
		VolumeM3,
		MAS.Peso_Bruto_EM,
		MAS.Peso_Liquido_EM Peso_Net_EM,
		VM.Qtd_Vol_EM,
		TE.ISO_CODE,
		N.NCM,
		Lacre_02_EM,
		
		Lacre_03_EM
		--TCC.Nome_Tp_Carga
		
		--Dt_Vcto_Devol_EM,
		--Dt_Devol_EM,
		--Nome_Tp_cont ,
		--NG.Descr					Packages_GOODS,
		--HOU.Obs_HEM					Marks_Numbers,
		--HOU.Peso_Bruto_HEM			Gross_Weight,
		--HOU.Peso_Liquido_HEM		Net_Weight,
		--convert(varchar(10),LLP.Dt_Impres_LEM,103) Dated_At,
		--[dbo].[Qty_Container](@processo) qtde
	from 
		container_mas_exp_mar MAS
		Left Outer Join Tipo_Container TC on TC.cd_tp_cont=MAS.cd_tp_cont
		Left Outer Join Container_Hou_exp_Mar CHOU on MAS.Num_Proc_MeM = CHOU.Num_Proc_MeM and MAS.Item_Cont_EM = CHOU.Item_Cont_EM   
		join vwHouse_Exp HOU on CHOU.Num_proc_hem = HOU.Num_Proc
		left join volume_Exp_Mar VM on CHOU.Num_proc_hem = VM.Num_proc_hem and CHOU.Item_Cont_EM = VM.Item_Cont_EM
		left join Tipo_Embalagem TE on VM.Cd_Tp_Embal = TE.Cd_Tp_Embal
		left join NCM N on VM.ID_NCM = N.ID_NCM
		--left outer join house_exp_mar HOU on HOU.num_proc_HeM = CHOU.Num_Proc_HeM
		--Left Outer Join LLP_exp_mar LLP on HOU.Num_Proc_HeM = LLP.Num_Proc_LeM
		--Left Outer Join Tipo_Carga TCC on LLP.Cd_Tp_Carga = TCC.Cd_Tp_Carga and TCC.Ativo_TP = 'S'
		--Left Outer Join Nature_Goods NG on HOU.num_proc_HeM = NG.Num_proc  
	where
		CHou.num_proc_hem=@Processo

order by 
	CHOU.Item_Cont_EM


GO
