SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerItem_Ins](
@ID	bigint,
@ID_Item int,
@Product_ID	varchar(50),
@Qty	decimal(15,2),
@UOM_Siscomex	varchar(50),
@UOM	varchar(50),
@Net_Weight	decimal(12,4),
@Unit_Price	decimal(12,4),
@NCM	varchar(50),
@ID_RM	varchar(50),
@Item	int,
@Num_Pedido varchar(50),
@Full_Description	varchar(max)
)
as


	insert INTO 
			IBROKER_Item_V2
			(
				ID,
				ID_Item,
				Product_ID,
				Qty,
				UOM_Siscomex,
				UOM,
				Net_Weight,
				Unit_Price,
				NCM,
				ID_RM,
				Item,
				Num_pedido,
				Full_Description
			)
	values
	(
				@ID,
				@ID_Item,
				@Product_ID,
				@Qty,
				@UOM_Siscomex,
				@UOM,
				@Net_Weight,
				@Unit_Price,
				@NCM,
				@ID_RM,
				@Item,
				@Num_pedido,
				@Full_Description
	)
GO
