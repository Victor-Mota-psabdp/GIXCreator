SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spBase_Nota_Fiscal_Erro_ProtInex_Upd]
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

	if exists(SELECT Dt_Protocolo,Protocolo from Base_Nota_Fiscal WITH(NOLOCK) where Nota_Fiscal =@Nota_Fiscal  and Ref_Acesso = @Site and Protocolo is not null)
	begin
		Insert INTO Base_Nota_Fiscal_Erro_ProtInex(Nota_Fiscal,Ref_Acesso,XML_DOC,Nome_Arquivo,Codigo,Mensagem,Correcao,dt_Protocolo,protocolo,Dt_Ins)			
		SELECT Nota_Fiscal,Ref_Acesso,@XML_DOC,@Nome_Arquivo,@Codigo,@Mensagem,@Correcao,Dt_Protocolo,Protocolo,getdate() 
		from Base_Nota_Fiscal WITH(NOLOCK) 
		where Nota_Fiscal =@Nota_Fiscal  and Ref_Acesso = @Site
	
		update Base_Nota_Fiscal set Dt_Protocolo=null, Protocolo=null where Nota_Fiscal =@Nota_Fiscal  and Ref_Acesso = @Site and Protocolo is not null
	END		
		
End




GO
