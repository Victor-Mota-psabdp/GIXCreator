SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Complementar_Temp_New
CREATE Procedure [dbo].[spATLANTIS_Pedido_Det_Complementar_Temp_New_Sel]
(
	--@ID	BIGINT
	@ID_House_Temp BIGINT
)

as
	select 
		ID,cd_pedido,cd_produto,Name_Produto,Item,Lote,cd_usuario,Dt_ins,Cd_Pes_Fabricante,
		Name_Pes_Fabricante,Cd_Pais_Fabricante,Name_Pais_Fabricante,Vlr_FOB,ID_TP_AC,Name_AC,
		ID_House_Temp,ID_Req,Intl_Reference
	from 
		Pedido_Det_Complementar_Temp_New
	where
		--ID = @ID
		ID_House_Temp = @ID_House_Temp

GO
