SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Container_Temp_Additional_Info
CREATE Procedure [dbo].[spATLANTIS_Container_Temp_Additional_Info_Sel]--'2'
(
	@ID	BIGINT
)

as
	select ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,Item_Cont_IM,
			Cd_Tp_Cont,Num_Cont_IM,
			dt_entregaPlanta,dt_entregaArmazem,dt_saidaArmazem,dt_saidaVazio,local_entrega,
			dt_devolucao,local_entrega_vazio,Mercadoria,cd_usuario,dt_ins,ativo,Peso_Bruto_EM_VGM,
			UOM_VGM,Dt_Envio_VGM,Nome_Responsavel_VGM,Metodo_VGM,TatcNumber,dt_ReleaseTatc,Itinerary_ID
	from Container_Temp_Additional_Info
	where
		ID = @ID

GO
