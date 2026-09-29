SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  Procedure [dbo].[spPackingListVolume_Rel] --'EOCSR20080402401'

@Processo varchar(16)

AS
-- EXPORTAÇÃO AEREA --
	select
		Marca_EA,sum(Qtd_Vol_EA) Qtd_Vol_EA, TE.Nome_tp_embal,Contra_Marca, Item_EA Item
	from
		volume_exp_aer VOL
		Left Join Tipo_Embalagem TE  on TE.cd_tp_embal	=VOL.cd_tp_embal
	where
		num_proc_hea = @Processo
	Group by
		Qtd_Vol_EA,TE.Nome_tp_embal,Marca_EA,Contra_Marca,Item_EA
--	Order by 
--		1

Union all

-- EXPORTAÇÃO MARITMA --
	select
		Marca_EM,sum(Qtd_Vol_EM) Qtd_Vol_EM, TE.Nome_tp_embal,  Contra_Marca, Item_EM
	from
		volume_exp_mar VOL
		Left Join Tipo_Embalagem TE  on TE.cd_tp_embal	=VOL.cd_tp_embal
	where
		num_proc_hem = @Processo
	Group by
		Qtd_Vol_EM, TE.Nome_tp_embal, Marca_EM, Contra_Marca,Item_EM
--	Order by 
--		1


Union all
-- EXPORTAÇÃO OUTROS --
	select
		 Marca_EO,sum(Qtd_Vol_EO) Qtd_Vol_EO, TE.Nome_tp_embal, Contra_Marca, Item_EO
	from
		volume_exp_out VOL
		Left Join Tipo_Embalagem TE  on TE.cd_tp_embal	=VOL.cd_tp_embal
	where
		num_proc_heo = @Processo
	Group by
		Marca_EO,Qtd_Vol_EO, TE.Nome_tp_embal,  Contra_Marca,Item_EO
--	Order by 
--		1





GO
