SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Produto_CHB_Det_Sel]--'15284','','D'
(
	@cd_prod		INT,
	@cd_tp_tx		varchar(6),
	@Tipo			char(1)
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
			convert(varchar(10),'Saved')		[Status],
			convert(varchar(10),PD.cd_prod)		[Code],			
			PC.cd_Proc_Cliente					[Product Code],
			PC.Produto_Descr					[Product Description],
			PC.cd_Cliente						[Group Code], 
			G.apelido							[Group Name],
			PD.Cd_Tp_Tx							[Charge Code],
			TP.Nome_Tp_Tx						[Charge Name],
			CONVERT(DECIMAL(18,2),Porcentagem)	[Percentage]
		from Produto_CHB_Det PD with(nolock)
			join Produto_Cliente PC on PC.cd_prod = PD.cd_prod
			join Pessoa G with(nolock) on G.Cd_Pes = PC.cd_Cliente
			LEFT join Tipo_Taxa TP with(nolock) on TP.cd_tp_tx=PD.cd_tp_tx	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			convert(varchar(10),'Saved')		[Status],
			convert(varchar(10),PD.cd_prod)		[Code],			
			PC.cd_Proc_Cliente					[Product Code],
			PC.Produto_Descr					[Product Description],
			PC.cd_Cliente						[Group Code], 
			G.apelido							[Group Name],
			PD.Cd_Tp_Tx							[Charge Code],
			TP.Nome_Tp_Tx						[Charge Name],
			CONVERT(DECIMAL(18,2),Porcentagem)	[Percentage]
		from Produto_CHB_Det PD with(nolock)
			join Produto_Cliente PC on PC.cd_prod = PD.cd_prod
			join Pessoa G with(nolock) on G.Cd_Pes = PC.cd_Cliente
			LEFT join Tipo_Taxa TP with(nolock) on TP.cd_tp_tx=PD.cd_tp_tx	
		where
			PD.cd_prod = @cd_prod
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			convert(varchar(10),'Saved')		[Status],
			convert(varchar(10),PD.cd_prod)		[Code],			
			PC.cd_Proc_Cliente					[Product Code],
			PC.Produto_Descr					[Product Description],
			PC.cd_Cliente						[Group Code], 
			G.apelido							[Group Name],
			PD.Cd_Tp_Tx							[Charge Code],
			TP.Nome_Tp_Tx						[Charge Name],
			CONVERT(DECIMAL(18,2),Porcentagem)	[Percentage]
		from Produto_CHB_Det PD with(nolock)
			join Produto_Cliente PC on PC.cd_prod = PD.cd_prod
			join Pessoa G with(nolock) on G.Cd_Pes = PC.cd_Cliente
			LEFT join Tipo_Taxa TP with(nolock) on TP.cd_tp_tx=PD.cd_tp_tx	
		where
			PD.cd_prod = @cd_prod and Pd.Cd_Tp_Tx = @cd_tp_tx
	End


--ALTER PROCEDURE [dbo].[spATL_Produto_CHB_Det_Sel]--'15284','','D'
--(
--	@cd_prod		INT,
--	@cd_tp_tx		varchar(6),
--	@Tipo			char(1)
--)
--as

--/*
--A, /// Todos os registros - Existentes
--B, /// Todos os registros - Ativos
--C, /// Busca pelo Codigo - Existentes
--D, /// Busca pelo Codigo - Ativos
--N, /// Busca pelo Nome - Existentes
--O /// Busca pelo Nome - Ativos
--*/

--if @Tipo = 'A' or @Tipo = 'B'
--	Begin
--		select 
--			convert(varchar(10),'Saved') Status,
--			--cd_prod [Code],
--			PD.Cd_Tp_Tx, TP.Nome_Tp_Tx,
--			CONVERT(DECIMAL(18,2),Porcentagem) Porcentagem
--		from Produto_CHB_Det PD with(nolock)
--			LEFT join Tipo_Taxa TP with(nolock) on TP.cd_tp_tx=PD.cd_tp_tx
		
	
--	End

--if @Tipo = 'C' or @Tipo = 'D'
--	Begin
--		select 
--			convert(varchar(10),'Saved') Status,
--			--PD.cd_prod [Code],
--			PD.Cd_Tp_Tx, TP.Nome_Tp_Tx, 
--			CONVERT(DECIMAL(18,2),Porcentagem) Porcentagem
--		from Produto_CHB_Det PD with(nolock)
--			LEFT join Tipo_Taxa TP with(nolock) on TP.cd_tp_tx=PD.cd_tp_tx	
--		where
--			PD.cd_prod = @cd_prod
--	End	
	
--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		select 
--			convert(varchar(10),'Saved') Status,
--			--PD.cd_prod [Code],
--			PD.Cd_Tp_Tx, TP.Nome_Tp_Tx, 
--			CONVERT(DECIMAL(18,2),Porcentagem) Porcentagem
--		from Produto_CHB_Det PD with(nolock)
--			LEFT join Tipo_Taxa TP with(nolock) on TP.cd_tp_tx=PD.cd_tp_tx	
--		where
--			PD.cd_prod = @cd_prod and Pd.Cd_Tp_Tx = @cd_tp_tx
--	End

GO
