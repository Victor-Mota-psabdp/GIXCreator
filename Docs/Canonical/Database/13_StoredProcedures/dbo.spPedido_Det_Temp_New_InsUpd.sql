SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Temp_New 
CREATE Procedure [dbo].[spPedido_Det_Temp_New_InsUpd] 
(	
	@ID					bigint,
	@Cd_Pedido			varchar(200),
	@Cd_Produto			varchar(200),
	@Name_Produto		varchar(200),
	@Lote				varchar(200),
	@Qty				varchar(200),
	@Vlr_Item			varchar(200),
	@Peso_Item			varchar(200),
	@UoM				varchar(200),
	@Name_UoM			varchar(200),
	@Item				varchar(200),
	@NCM				varchar(200),
	@NATOP				varchar(200),
	@UOM_PRC			varchar(200),
	@SAP_Company		varchar(200),
	@Peso_UOM			varchar(200),
	@Vlr_Total_Item		varchar(200),
	@Contract			varchar(200),
	@Requision			varchar(200),
	@PO_GRP				varchar(200),
	@Finalidade			varchar(200),
	@Peso_Invoice		varchar(200),
	@Peso_Bruto_TOT		varchar(200),
	@Peso_Liquido_TOT	varchar(200),
	@DN_Valida			varchar(200),
	@In_Progress		varchar(200),
	@Requerimento		varchar(200),
	@Total_Invoice_USD		varchar(200),
	@Total_Invoice_Local	varchar(200),
	@UPC					varchar(200),
	@Vlr_Frete				varchar(200),
	@Qtde_Embal				varchar(200),
	@Cd_Tp_Embal			varchar(200),
	@Name_Embal				varchar(200)
)


as

BEGIN TRANSACTION
	
	--Retirar "." do NCM
	set @NCM = replace(left(@NCM,8),'.','')
	if @Item is null	
			begin
				set @Item=(SELECT Isnull(max(Item),0)+1  FROM Pedido_Det_Temp_New Where ID=@ID) 
			end	

	IF NOT EXISTS(SELECT ID FROM Pedido_Det_Temp_New with(nolock) Where ID=@ID and Item = @Item)		
		BEGIN	
			INSERT INTO
				Pedido_Det_Temp_New
					(	ID,
						Cd_Pedido,Cd_Produto,Name_Produto,Lote,Qty,Vlr_Item,Peso_Item,UoM,Name_UoM,Item,NCM,
						NATOP,UOM_PRC,SAP_Company,Peso_UOM,Vlr_Total_Item,Contract,Requision,PO_GRP,Finalidade,
						Peso_Invoice,Peso_Bruto_TOT,Peso_Liquido_TOT,DN_Valida,In_Progress,Requerimento,Total_Invoice_USD,
						Total_Invoice_Local,UPC,Vlr_Frete,Qtde_Embal,Cd_Tp_Embal,Name_Embal	
					)
			VALUES
					(
						@ID,
						@Cd_Pedido,@Cd_Produto,@Name_Produto,@Lote,@Qty,@Vlr_Item,@Peso_Item,@UoM,
						@Name_UoM,@Item,@NCM,@NATOP,@UOM_PRC,@SAP_Company,@Peso_UOM,@Vlr_Total_Item,
						@Contract,@Requision,@PO_GRP,@Finalidade,@Peso_Invoice,@Peso_Bruto_TOT,@Peso_Liquido_TOT,
						@DN_Valida,@In_Progress,@Requerimento,@Total_Invoice_USD,@Total_Invoice_Local,@UPC,@Vlr_Frete,
						@Qtde_Embal,@Cd_Tp_Embal,@Name_Embal
					) 
		END

	ELSE
		BEGIN
			UPDATE Pedido_Det_Temp_New
				SET
					
					Cd_Pedido = @Cd_Pedido,
					Cd_Produto = @Cd_Produto,				
					Name_Produto=@Name_Produto,
					Lote = @Lote,					
					Qty=@Qty,
					Vlr_Item=@Vlr_Item,
					Peso_Item=@Peso_Item,
					UoM=@UoM,
					Name_UoM=@Name_UoM,					
					NCM=@NCM,
					NATOP=@NATOP,
					UOM_PRC=@UOM_PRC,
					SAP_Company=@SAP_Company,
					Peso_UOM=@Peso_UOM,
					Vlr_Total_Item=@Vlr_Total_Item,
					Contract=@Contract,
					Requision=@Requision,
					PO_GRP=@PO_GRP,
					Finalidade=@Finalidade,
					Peso_Invoice=@Peso_Invoice,
					Peso_Bruto_TOT=@Peso_Bruto_TOT,
					Peso_Liquido_TOT=@Peso_Liquido_TOT,
					DN_Valida=@DN_Valida,
					In_Progress=@In_Progress,
					Requerimento=@Requerimento,
					Total_Invoice_USD=@Total_Invoice_USD,
					Total_Invoice_Local=@Total_Invoice_Local,
					UPC=@UPC,
					Vlr_Frete=@Vlr_Frete,
					Qtde_Embal=@Qtde_Embal,
					Cd_Tp_Embal=@Cd_Tp_Embal,
					Name_Embal=@Name_Embal
			WHERE
				ID=@ID and Item= @Item
				--Cd_Pedido=@Cd_Pedido and Item=@Item 
				--and lote=@lote and Cd_Produto=@Cd_Produto
		END
	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -2
		END

COMMIT TRANSACTION

GO
