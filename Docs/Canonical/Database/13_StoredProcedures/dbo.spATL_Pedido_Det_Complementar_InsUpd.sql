SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_HELp Pedido_Det_Complementar
CREATE Procedure [dbo].[spATL_Pedido_Det_Complementar_InsUpd] 
(	
    @Cd_Pedido			int,
	@Cd_Produto			int,
    --@Nome_Produto		VarChar(500),
	@Lote				varchar(30),
	@Item				varchar(6),
	@Cd_Usuario         varchar(10),
	@cd_pes_fabricante	varchar(10),
	@cd_pais_fabricante varchar(3),
	@Vlr_FOB			float,
	@ID_TP_AC           BigInt,
	@cd_tp_moeda		varchar(3)
)
as

BEGIN TRANSACTION

--	Declare @Cd_Grupo varchar(10)
--	Declare @cd_tp_Embal_Outer varchar(3) 
		
--	Set @Cd_Grupo = (Select Cd_Grupo from Pedido where cd_pedido=@cd_pedido)
	
--    IF @nome_produto is not NULL
--    Begin 
--        Set @Cd_Produto=(select cd_prod from produto_cliente where produto_descr=@nome_produto and Cd_Cliente=@Cd_Grupo)
--        if @Cd_Produto is NULL or @Cd_Produto = ''
--            begin
--                Set @Cd_Produto=(select cd_prod from produto_cliente where cd_proc_cliente=@nome_produto and Cd_Cliente=@Cd_Grupo)
--            end
--    END
		
----Ajusta ITEM qdo FMC ou Consagro
--	if @cd_grupo in ('362','P16997')
--		begin
--			set @Item = right(@Item,5)
--		end	

	IF NOT EXISTS(SELECT CD_PEDIDO FROM Pedido_Det_Complementar Where cd_pedido=@cd_pedido 
								and item=@item and lote=@lote and Cd_Produto=@Cd_Produto)
		BEGIN
			INSERT INTO Pedido_Det_Complementar
			(
				Cd_Pedido,Cd_Produto,Lote,Item,Dt_Ins,Cd_Usuario,cd_pes_fabricante,cd_pais_fabricante,
                Vlr_FOB,ID_TP_AC
				--,cd_tp_moeda	
			)
			VALUES
			(
				@Cd_Pedido,@Cd_Produto,@Lote,@Item,Getdate(),@Cd_Usuario,@cd_pes_fabricante,@cd_pais_fabricante,
                @Vlr_FOB,@ID_TP_AC
				--,@cd_tp_moeda
			) 
		END

	ELSE
		BEGIN
			UPDATE	
				Pedido_Det_Complementar
					SET					
					cd_pes_fabricante=@cd_pes_fabricante,
					cd_pais_fabricante=@cd_pais_fabricante,
					Vlr_FOB = @Vlr_FOB,
					ID_TP_AC = @ID_TP_AC
					--,	cd_tp_moeda = @cd_tp_moeda
			WHERe
				Cd_Pedido=@Cd_Pedido and Item=@Item and lote=@lote and Cd_Produto=@Cd_Produto
		END
	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -2
		END

COMMIT TRANSACTION

GO
