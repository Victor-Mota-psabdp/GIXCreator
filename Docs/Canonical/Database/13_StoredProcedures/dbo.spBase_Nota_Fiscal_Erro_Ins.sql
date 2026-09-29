SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 23/6/20 - commented included

CREATE procedure [dbo].[spBase_Nota_Fiscal_Erro_Ins]
(
	@Nota_Fiscal	varchar(8),
	@Site			char(1),
	@XML_DOC		nvarchar(MAX),
	@Nome_Arquivo	varchar(500),
	@Codigo			varchar(10),		
	@Mensagem		nvarchar(MAX),
	@Correcao		nvarchar(MAX)
	
)
as

Begin 

	Insert INTO Base_Nota_Fiscal_Erro
		(Nota_Fiscal,Ref_Acesso,XML_DOC,Nome_Arquivo,Codigo,Mensagem,Correcao,Dt_Ins)			
		Values
		(@Nota_Fiscal,@Site,@XML_DOC,@Nome_Arquivo,@Codigo,@Mensagem,@Correcao,getdate())
		
	
	
	--Declare @Texto as varchar(100)
	--set @Texto = 'Esse RPS não foi enviado para a nossa base de dados'
	
	--if @Mensagem = @Texto
	--	begin
	--		update Base_Nota_Fiscal set dt_Protocolo = null,protocolo = null where Ref_Acesso = @Site 
	--		and Nota_Fiscal = @Nota_Fiscal
	--	End	
End




GO
