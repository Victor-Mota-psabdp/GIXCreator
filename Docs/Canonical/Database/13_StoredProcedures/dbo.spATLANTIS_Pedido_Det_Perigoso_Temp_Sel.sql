SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Perigoso_Temp
CREATE Procedure [dbo].[spATLANTIS_Pedido_Det_Perigoso_Temp_Sel]
(
	--@ID	BIGINT
	@ID_House_Temp BIGINT
)

as
	select 
		ID,cd_pedido,cd_produto,Name_Produto,Item,Lote,
		HAZMAT_CD,HAZMAT_CLASS_CD,HAZMAT_DESC,HAZMAT_CONTACT,HAZMAT_PAGE,HAZMAT_FPOINT,
		HAZMAT_FPOINT_CD,HAZMAT_PULL_DESC_FRM_BDP,HAZMAT_ORG_DESC,HAZMAT_DESC_QUAL,
		ID_House_Temp,ID_Req,Intl_Reference	
	from 
		Pedido_Det_Perigoso_Temp
	where
		--ID = @ID
		ID_House_Temp = @ID_House_Temp


GO
