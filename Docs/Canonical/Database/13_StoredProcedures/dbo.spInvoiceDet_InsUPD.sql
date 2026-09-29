SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Invoice_Det add NF varchar(50)
--alter table Invoice_Det add dtNF Datetime


CREATE	Procedure [dbo].[spInvoiceDet_InsUPD]

	@ID_Inv				int,
	@Cd_Pedido			int,
	@Item				int,
	@Cd_Proc_Cliente	varchar(30),
	@Quantidade			Decimal(10,2),
	@Peso_Liquido		float,
	@Peso_Bruto			float,
	@Preco_Unit			float,
	@Embalagem			varchar(30),
	@Capacidade			float,
	@Tipo_Unid			varchar(2),
	@Usuario			varchar(50),
	@Incluso			char(1),
	@Descr_Adicional	varchar(100),
	@NF					varchar(50),
	@dtNF				datetime

AS

Declare	@Cd_Produto	int
Declare	@Cd_tp_embal	varchar(3)
Declare @Cd_Usuario	varchar(6)
Declare @Cd_Pes_Grupo varchar(10)

BEGIN TRANSACTION

	set @Cd_Pes_Grupo = (select cd_grupo from pedido where cd_pedido = @Cd_Pedido)

	set @cd_produto = (select cd_prod from produto_cliente where Cd_Proc_Cliente = @Cd_Proc_Cliente and cd_cliente = @Cd_Pes_Grupo)
	set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
	set @Cd_Usuario = (Select Cd_usuario from usuario where Nome_usuario = @Usuario)

 	if not exists (select ID_Inv from Invoice_Det where Cd_pedido=@cd_pedido and cd_produto=@cd_Produto and ID_Inv=@ID_Inv and Item=@Item)
		BEGIN
			INSERT INTO
				Invoice_Det
				(
					ID_Inv, Cd_Pedido, Item, Cd_Produto, Quantidade,
					Peso_Liquido, Peso_Bruto, Preco_Unit, Cd_Embalagem, Descr_Adicional,
					Capacidade, Tipo_Unid, Incluso, Cd_Usuario,NF,DtNF
				)
				VALUES
				(
					@ID_Inv, @CD_Pedido, @Item, @Cd_Produto, @Quantidade,
					@Peso_Liquido, @Peso_Bruto, @Preco_Unit, @Cd_tp_Embal, @Descr_Adicional,
					@Capacidade, @Tipo_Unid, @Incluso, @Cd_Usuario,@NF,@dtNF
				)
		END
	else
		BEGIN
			UPDATE
				Invoice_Det
			SET
				Quantidade=@Quantidade, 
				Peso_Liquido=@Peso_Liquido, Peso_Bruto=@Peso_Bruto,
				Preco_Unit=@Preco_Unit, Cd_Embalagem=@Cd_tp_Embal, Descr_Adicional=@Descr_Adicional,
				Capacidade=@Capacidade, Tipo_Unid=@Tipo_Unid,
				Incluso=@Incluso, Cd_Usuario=@Cd_Usuario,
				NF=@NF,dtNF=@dtNF
				
			WHERE
				Cd_Produto=@Cd_Produto and Cd_Pedido=@Cd_Pedido and ID_INV=@ID_Inv and Item=@Item

		END
				

	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION










GO
