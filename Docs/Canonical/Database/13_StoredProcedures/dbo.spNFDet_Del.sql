SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE      	 Procedure spNFDet_Del 		

				@ID_NF		int,
				@Cliente	Varchar(50),
				@Pedido		Varchar(10),
				@Produto	Varchar(10),
				@Modal		char(1)

AS
Begin Transaction

	Declare	@Cd_Cliente	Varchar(10)
	Declare @Cd_Pedido	int
	Declare	@Cd_Produto	int

	Set @Cd_Cliente = (Select Cd_Pes from Pessoa where apelido = @Cliente)
	Set @Cd_Pedido = (select Cd_Pedido from Pedido join pessoa pp on (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE) where Num_Pedido=@Pedido and apelido=@cliente and cd_modal=@Modal)
	Set @Cd_Produto = (select Cd_Prod from produto_cliente where cd_proc_Cliente=@Produto and cd_cliente=@cd_cliente) 

	delete Nota_Fiscal_Cliente_Det where Id_NF = @ID_NF and Cd_Pedido= @Cd_Pedido and cd_produto = @Cd_Produto			

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1

		END

Commit Transaction 












GO
