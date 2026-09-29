SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerCAP2_Ins](
		@ID	bigint,
		@Qty_Item	int,
		@Cod_Currency_Order	varchar(50),
		@Currency_Order	varchar(50),
		@Order_Value	decimal(15,2),
		@Cod_Currency_Freight	varchar(50),
		@Currency_Freight	varchar(50),
		@Freight_Value	decimal(15,2),
		@Freight_Type	varchar(50),
		@Incoterm	varchar(50),
		@Incoterm_Descr	varchar(50),
		@Cod_Currency_Invoice	varchar(50),
		@Currency_Invoice	varchar(50),
		@Invoice_Value	decimal(15,2)
)
as


	insert INTO 
			IBROKER_CAP2_V2
			(
				ID,
				Qty_Item,
				Cod_Currency_Order,
				Currency_Order,
				Order_Value,
				Cod_Currency_Freight,
				Currency_Freight,
				Freight_Value,
				Freight_Type,
				Incoterm,
				Incoterm_Descr,
				Cod_Currency_Invoice,
				Currency_Invoice,
				Invoice_Value
			)
	values
	(
				@ID,
				@Qty_Item,
				@Cod_Currency_Order,
				@Currency_Order,
				@Order_Value,
				@Cod_Currency_Freight,
				@Currency_Freight,
				@Freight_Value,
				@Freight_Type,
				@Incoterm,
				@Incoterm_Descr,
				@Cod_Currency_Invoice,
				@Currency_Invoice,
				@Invoice_Value
	)
GO
