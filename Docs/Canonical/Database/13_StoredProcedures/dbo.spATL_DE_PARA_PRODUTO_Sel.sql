SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help DE_PARA_PRODUTO
CREATE procedure [dbo].[spATL_DE_PARA_PRODUTO_Sel](
	@GMID 				varchar(30),
	@Cd_Cliente			varchar(10),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			P.cd_prod					[Code],
			PC.GMID						[Product Code],
			PC.cd_Cliente				[Group Code],
			G.Apelido					[Group Name],
			PC.GMID_Descr_Curta			[GMID Short Description],
			Trade_Product_Code			[Product Trade Code],
			Trade_Product_Descr			[Product Trade Description],
			Plan_Product_Code			[Product Plan Code],
			Plan_Product_Descr			[Product Plan Description],
			Product_Center_Code     	[Product Center Code],
			Product_Center_Descr		[Product Center Description],
			Performance_Center_Code 	[Performance Center Code],
			Performance_Center_Descr 	[Performance Center Description],
			Value_Center_Code 			[Value Center Code],
			Value_Center_Descr 			[Value Center Description],
			Business_Code 				[Business Code],
			Business_Descr				[Business Description],
			Business_Group_Code			[Business Group Code],
			Business_Group_Descr		[Business Group Description],
			P_Descricao,
			S_Descricao,
			ITO_Especialista
		from DE_PARA_PRODUTO PC with(nolock)
			join Produto_Cliente P on P.cd_Proc_Cliente = pc.GMID AND pc.Cd_Cliente = p.cd_Cliente
			join Pessoa G with(nolock) on G.Cd_Pes = PC.cd_Cliente
	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			P.cd_prod					[Code],
			PC.GMID						[Product Code],
			PC.cd_Cliente				[Group Code],
			G.Apelido					[Group Name],
			PC.GMID_Descr_Curta			[GMID Short Description],
			Trade_Product_Code			[Product Trade Code],
			Trade_Product_Descr			[Product Trade Description],
			Plan_Product_Code			[Product Plan Code],
			Plan_Product_Descr			[Product Plan Description],
			Product_Center_Code     	[Product Center Code],
			Product_Center_Descr		[Product Center Description],
			Performance_Center_Code 	[Performance Center Code],
			Performance_Center_Descr 	[Performance Center Description],
			Value_Center_Code 			[Value Center Code],
			Value_Center_Descr 			[Value Center Description],
			Business_Code 				[Business Code],
			Business_Descr				[Business Description],
			Business_Group_Code			[Business Group Code],
			Business_Group_Descr		[Business Group Description],
			P_Descricao,
			S_Descricao,
			ITO_Especialista
		from DE_PARA_PRODUTO PC with(nolock)
			join Produto_Cliente P on P.cd_Proc_Cliente = pc.GMID AND pc.Cd_Cliente = p.cd_Cliente
			join Pessoa G with(nolock) on G.Cd_Pes = PC.cd_Cliente
		where
			PC.GMID = @GMID and PC.Cd_Cliente = @Cd_Cliente
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			P.cd_prod					[Code],
			PC.GMID						[Product Code],
			PC.cd_Cliente				[Group Code],
			G.Apelido					[Group Name],
			PC.GMID_Descr_Curta			[GMID Short Description],
			Trade_Product_Code			[Product Trade Code],
			Trade_Product_Descr			[Product Trade Description],
			Plan_Product_Code			[Product Plan Code],
			Plan_Product_Descr			[Product Plan Description],
			Product_Center_Code     	[Product Center Code],
			Product_Center_Descr		[Product Center Description],
			Performance_Center_Code 	[Performance Center Code],
			Performance_Center_Descr 	[Performance Center Description],
			Value_Center_Code 			[Value Center Code],
			Value_Center_Descr 			[Value Center Description],
			Business_Code 				[Business Code],
			Business_Descr				[Business Description],
			Business_Group_Code			[Business Group Code],
			Business_Group_Descr		[Business Group Description],
			P_Descricao,
			S_Descricao,
			ITO_Especialista
		from DE_PARA_PRODUTO PC with(nolock)
			join Produto_Cliente P on P.cd_Proc_Cliente = pc.GMID AND pc.Cd_Cliente = p.cd_Cliente
			join Pessoa G with(nolock) on G.Cd_Pes = PC.cd_Cliente
		where
			PC.GMID = @GMID and PC.Cd_Cliente = @Cd_Cliente
	End
	
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select Cd_Tp_End[Code], Nome_Tp_End [Type of Address] from Tipo_Endereco
--		where Nome_Tp_End = @Nome_Tp_End and Cd_Tp_End<> @Cd_Tp_End
--	End

GO
