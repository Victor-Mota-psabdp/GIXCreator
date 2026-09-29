SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_Pedido_Det_InsUpd] 
(
	@Cd_Pedido		Int,
    @cd_produto     Int,
	@Lote			VarChar(30),
	@Item			Varchar(6),
	@Requerimento	Varchar(30),
	@UOM			VarChar(5),
	@Qty			float,
	@Vlr_Item		float,
	@Vlr_Total_Item float,
	@UOM_PRC		varchar(10),
	@Peso_UOM		Varchar(10),
	@Peso_Item		float,	
	@Peso_Bruto_TOT	float,
	@Peso_Liquido_TOT float,
	@Peso_Invoice	float,
	@SAP_Company	varchar(5),
	@Contract		Varchar(15),
	@NATOP			varchar(20),
	@Finalidade		Varchar(30),
	@PO_GRP			Varchar(5),
	@In_Progress	char(1),
	@Requision		Varchar(15),
	@NCM			VarChar(12), -- 12 because of NCM in ARG
	@UPC			varchar(14),
	@Qtde			varchar(5),
	@Cd_tp_embal varchar(3)
)

as

BEGIN TRANSACTION

	-- Declare @Cd_Grupo varchar(10)

	--Retirar "." do NCM
	--set @NCM = replace(left(@NCM,8),'.','')
	set @NCM = replace(@NCM,'.','')
	
-- 	Set @Cd_Grupo = (Select Cd_Grupo from Pedido where cd_pedido=@cd_pedido)
-- 	--if @Cd_Grupo = '1'
-- 	--	Begin 
-- 	--		Set @Cd_Produto=(select cd_prod from produto_cliente where produto_descr=@nome_produto and Cd_Cliente in ('1','P17842'))
-- 	--	end
-- 	--else
-- 	--	Begin
-- 			Set @Cd_Produto=(select cd_prod from produto_cliente where produto_descr=@nome_produto and Cd_Cliente=@Cd_Grupo)
-- 			if @Cd_Produto is NULL or @Cd_Produto = ''
-- 				begin
-- 					Set @Cd_Produto=(select cd_prod from produto_cliente where cd_proc_cliente=@nome_produto and Cd_Cliente=@Cd_Grupo)
-- 				end
-- 		--End
-- --Ajusta ITEM qdo FMC ou Consagro
-- 	if @cd_grupo in ('362','P16997')
-- 		begin
-- 			set @Item = right(@Item,5)
-- 		end

	IF NOT EXISTS(SELECT CD_PEDIDO FROM PEDIDO_DET Where cd_pedido=@cd_pedido and item=@item and lote=@lote and Cd_Produto=@Cd_Produto)
		BEGIN
			INSERT INTO PEDIDO_DET
			(
				Cd_Pedido,Cd_Produto,Lote,Qty,Vlr_Item,Peso_Item,UOM,Item,NCM,NATOP,UOM_PRC,SAP_Company,Peso_UOM,
                Vlr_Total_Item,[Contract],Requision,PO_GRP,Peso_Bruto_TOT,Peso_Liquido_TOT,Finalidade,Peso_Invoice,
                In_Progress,Requerimento,UPC,Qtde_Embal,cd_tp_embal					
            )
			VALUES
			(
                @Cd_Pedido,@Cd_Produto,@Lote,@Qty,@Vlr_Item,@Peso_Item,@UOM,@Item,@NCM,left(@NATOP,5),@UOM_PRC,@SAP_Company,@Peso_UOM,
                @Vlr_Total_Item,@Contract,@Requision,@PO_GRP,@Peso_Bruto_TOT,@Peso_Liquido_Tot,@Finalidade,@Peso_Invoice,
                @In_Progress,@Requerimento,@UPC,@Qtde,@cd_tp_embal
            ) 
		END
	ELSE
		BEGIN
			UPDATE	
				PEDIDO_DET
					SET
					Qty=@QTY,
					Peso_Item=@Peso_Item,
					Vlr_Item=@Vlr_Item,
					UOM=@UOM,
					Item=@Item,
					NCM=@NCM,
					NATOP=left(@NATOP,5),
					UOM_PRC=@UOM_PRC,
					SAP_Company=@SAP_Company,
					Peso_UOM=@Peso_UOM,
					Vlr_Total_Item=@Vlr_Total_Item,
					[Contract] = @Contract,
					Requision = @Requision,
					PO_GRP= @PO_GRP,
					Peso_Bruto_TOT=@Peso_Bruto_TOT,
					Peso_Liquido_Tot=@Peso_Liquido_Tot,
					Finalidade=@Finalidade,
					Peso_Invoice=@Peso_Invoice,
					In_Progress=@In_Progress,
					Requerimento=@Requerimento,
					UPC=@UPC,
					Qtde_Embal=@Qtde,
					Cd_tp_embal=@Cd_tp_embal
			WHERe
				Cd_Pedido=@Cd_Pedido and Item=@Item and lote=@lote and Cd_Produto=@Cd_Produto
		END
	--IF @@ERROR <> 0 
	--	BEGIN
	--		ROLLBACK TRANSACTION
	--		RETURN -2
	--	END

COMMIT TRANSACTION

GO
