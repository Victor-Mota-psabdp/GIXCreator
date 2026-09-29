SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Pessoa where Apelido like 'grupo givaudan%'
--P000021008	GRUPO GIVAUDAN
--P000021890	GRUPO GIVAUDAN AROMA

CREATE Procedure [dbo].[spATL_ProdutoCHB_UPD]

	@cd_Proc_Cliente	varchar(30),
	@DescrprodL			varchar(MAX),
	@cd_cliente			varchar(25)
AS

Begin Transaction

	declare @cd_prod INT
	--set @cd_prod = (select cd_prod from Produto_Cliente where cd_Proc_Cliente = @cd_Proc_Cliente and cd_Cliente = '1')
	--set @cd_prod = (select cd_prod from Produto_Cliente where cd_Proc_Cliente = @cd_Proc_Cliente and cd_Cliente = 'P000021008')	
	set @cd_prod = (select cd_prod from Produto_Cliente where cd_Proc_Cliente = @cd_Proc_Cliente and cd_Cliente = @cd_cliente)	

	If exists (select cd_prod from produto_chb where cd_prod=@cd_prod)
		Begin
			Update
				Produto_chb
			Set				
				Descricao_longa=@DescrprodL				
			where
				cd_prod=@cd_prod
		End
				
				
Commit Transaction

--stored antiga
--ALTER Procedure [dbo].[spProdutoCHB_UPD]

--	@Cd_Prod		int,
--	@DescrprodL		varchar(max)
--AS

--Begin Transaction		

--	If exists (select cd_prod from produto_chb where cd_prod=@cd_prod)
--		Begin
--			Update
--				Produto_chb
--			Set				
--				Descricao_longa=@Descrprodl				
--			where
--				cd_prod=@cd_prod
--		End
				
				
--Commit Transaction


GO
