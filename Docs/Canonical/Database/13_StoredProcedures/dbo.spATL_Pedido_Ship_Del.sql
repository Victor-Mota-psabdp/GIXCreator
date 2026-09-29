SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Pedido_Ship_Del]

	@Num_Pedido	VarChar(30),
	@Prod_ID 	varchar(30),
	@Cliente	Varchar(50),
	@Processo	varchar(16),
	@Item		varchar(10),
	@Lote		varchar(30)
AS

BEGIN TRANSACTION

	Declare @Cd_Pedido	int
	Declare @Cd_Produto	int
	Declare @Cd_Cliente	varchar(10)

--Selecionar o Grupo
	Declare @cd_pes_grupo varchar(10)
	Set @Cd_Cliente = (Select top 1 Cd_pes from Pessoa where apelido = @Cliente)
	Set @cd_pes_grupo = (select top 1 cd_pes_grupo from pessoa_llp where cd_pes = @Cd_Cliente )

	Set @Cd_Pedido = (select distinct P.cd_pedido from pedido P join pedido_ship PS on PS.cd_pedido = P.cd_pedido where num_pedido = @Num_Pedido and num_proc = @Processo)
	Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente PC join Pedido_Ship PS on PS.Cd_Produto = PC.Cd_Prod where cd_proc_Cliente=@Prod_ID and num_proc = @Processo)

	DELETE Pedido_Ship where Lote = @lote and Item = @Item and Num_proc = @Processo and Cd_Pedido= @Cd_Pedido and cd_produto = @Cd_Produto

--Descobrir o que aconteceu no dia 8/9/2009 qdo sumiram os vinculos de JOB com RMs
	declare @Descricao varchar(100)
	set @Descricao = ('Ordem: ' + @Num_Pedido + ' Desvinculada!!!')
	declare @Seq int
	set @seq=(select max(HSGSEq) from hist_geral where hsgprocesso=@Processo) + 1
	insert into Hist_Geral Values(@Processo, @Seq, @cd_Cliente, 47,@Descricao , getdate(), null, 'ATL', null,'N','S',null)
-----------------------------------------------------------------------------------

	IF NOT EXISTS(SELECT CD_PEDIDO FROM PEDIDO_SHIP where cd_pedido = @cd_pedido)

		Begin	
			Update 
				Pedido
			Set
				Status = 'O' 

			where Num_Pedido=@Num_Pedido and (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE)
 		end

	Declare @NCM char(8)
	Declare @Id_NCM int
	
	Set @NCM = (select NCM from Pedido_det where cd_pedido = @cd_pedido and cd_produto = @Cd_Produto)
	Set @Id_NCM = (select Id_NCM from NCM where @NCM = NCM)
	
	DELETE Proc_NCM where num_proc = @Processo and ID_NCM = @Id_NCM

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION

GO
