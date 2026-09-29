SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Smart_XML
CREATE PROCEDURE [dbo].[spATL_Smart_XML_Sel]
(
	@ID_Smart			bigint,	
	@Num_Proc			varchar(16),	
	@Tipo				char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin			
		select 			
			E.ID_Smart							[Id], 		
			E.num_proc							[JOB],			
			E.XML_DOC							[XML_DOC],				
			E.Nome_Arquivo						[File Name],
			E.Dt_Ins							[Insert Date],
			E.Dt_Envio							[Sent Date]		
		from 
			ATL_INT.dbo.Smart_XML E  with(nolock)		
		where
			E.Dt_Envio is null
			
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 			
			E.ID_Smart							[Id], 		
			E.num_proc							[JOB],			
			E.XML_DOC							[XML_DOC],				
			E.Nome_Arquivo						[File Name],
			E.Dt_Ins							[Insert Date],
			E.Dt_Envio							[Sent Date]		
		from 
			ATL_INT.dbo.Smart_XML E  with(nolock)	
		where
			E.ID_Smart = @ID_Smart	
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 			
			E.ID_Smart							[Id], 		
			E.num_proc							[JOB],			
			E.XML_DOC							[XML_DOC],				
			E.Nome_Arquivo						[File Name],
			E.Dt_Ins							[Insert Date],
			E.Dt_Envio							[Sent Date]		
		from 
			ATL_INT.dbo.Smart_XML E  with(nolock)			
		where
			E.Num_Proc = @Num_Proc		
	End	

	

GO
