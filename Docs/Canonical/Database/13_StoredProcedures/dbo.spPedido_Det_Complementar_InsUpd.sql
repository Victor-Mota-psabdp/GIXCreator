SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spPedido_Det_Complementar_InsUpd] 
	@Cd_Pedido			Int,
	@Nome_Produto		VarChar(500),
	@Lote				VarChar(30),
	@Item				Varchar(6),
	@Usuario			varchar(50),
	@Fabricante			Varchar(50),
	@Pais_Fabricante	Varchar(50),
	@Vlr_FOB			float,
	@Nome_TP_AC			varchar(100)
as

BEGIN TRANSACTION

	Declare @cd_produto Int
	Declare @Cd_Grupo varchar(10)
	Declare @Cd_Usuario varchar(10)
	Declare @cd_pes_fabricante	varchar(10)
	Declare @cd_pais_fabricante varchar(3)
	Declare @ID_TP_AC BigInt
	Declare @cd_tp_Embal_Outer varchar(3) 
	
	Set @Cd_Usuario = (Select Cd_Usuario from Usuario where Nome_Usuario = @Usuario and Ck_Ativo=1)
	Set @cd_pes_fabricante = (Select top 1 Cd_pes from Pessoa where apelido = @Fabricante)
	Set @cd_pais_fabricante = (Select Cd_Pais from Pais where Nome_Pais = @Pais_Fabricante)
	Set @ID_TP_AC = (Select ID_TP_AC from Tipo_Acordo_Comercial where NOME_TP_AC = @Nome_TP_AC)
		
	Set @Cd_Grupo = (Select Cd_Grupo from Pedido where cd_pedido=@cd_pedido)
	
	Set @Cd_Produto=(select cd_prod from produto_cliente where produto_descr=@nome_produto and Cd_Cliente=@Cd_Grupo)
	if @Cd_Produto is NULL or @Cd_Produto = ''
		begin
			Set @Cd_Produto=(select cd_prod from produto_cliente where cd_proc_cliente=@nome_produto and Cd_Cliente=@Cd_Grupo)
		end
		
--Ajusta ITEM qdo FMC ou Consagro
	if @cd_grupo in ('362','P16997')
		begin
			set @Item = right(@Item,5)
		end	

	IF NOT EXISTS(SELECT CD_PEDIDO FROM Pedido_Det_Complementar Where cd_pedido=@cd_pedido 
								and item=@item and lote=@lote and Cd_Produto=@Cd_Produto)
		BEGIN
			INSERT INTO
				Pedido_Det_Complementar
					(
					Cd_Pedido,
					Cd_Produto,
					Lote,					
					Item,
					Dt_Ins,
					Cd_Usuario,
					cd_pes_fabricante,
					cd_pais_fabricante,
					Vlr_FOB	,
					ID_TP_AC	
					)
			VALUES
					(
					@Cd_Pedido,
					@Cd_Produto,
					@Lote,					
					@Item,
					Getdate(),
					@Cd_Usuario,
					@cd_pes_fabricante,
					@cd_pais_fabricante,
					@Vlr_FOB,
					@ID_TP_AC
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
