SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_AX_Master_XML_Sel]--'31','','B'
(
	@ID_AX				bigint,
	@Num_Proc			Varchar(16),
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
sp_help AX_Master_XML
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin			
		select 			
			E.ID_AX								[Code],
			E.num_proc							[JOB],
			E.Tipo								[Instruction Type Code],	
			C.Nome_Tp_Instrucao					[Instruction Type Name],
			E.Dt_Envio							[Sent Date],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[File Name],
			E.MessageId							[MessageId],
			isnull(E.Verificado,0)						[Verified],
			E.Dt_Reenvio						[Resend Date]
		from AX_Master_XML E  with(nolock)
			Join  Tipo_Instrucao C with(nolock) on E.Tipo=C.Cd_Tp_Instrucao		
		where
			E.ID_AX = @ID_AX		
			
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
			select 			
			E.ID_AX								[Code],
			E.num_proc							[JOB],
			E.Tipo								[Instruction Type Code],	
			C.Nome_Tp_Instrucao					[Instruction Type Name],
			E.Dt_Envio							[Sent Date],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[File Name],
			E.MessageId							[MessageId],
			isnull(E.Verificado,0)					[Verified],
			E.Dt_Reenvio						[Resend Date]
		from AX_Master_XML E  with(nolock)
			Join  Tipo_Instrucao C with(nolock) on E.Tipo=C.Cd_Tp_Instrucao	
		where
			E.Num_Proc = @Num_Proc  
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 			
			E.ID_AX								[Code],
			E.num_proc							[JOB],
			E.Tipo								[Instruction Type Code],	
			C.Nome_Tp_Instrucao					[Instruction Type Name],
			E.Dt_Envio							[Sent Date],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[File Name],
			E.MessageId							[MessageId],
			isnull(E.Verificado,0)				[Verified],
			E.Dt_Reenvio						[Resend Date],

			DATEADD(day,1,E.Dt_Envio)			[DATEADD],
			 DATEADD(MONTH,-1,GETDATE())		[MONTHADD]
		from AX_Master_XML E  with(nolock)
			Join Tipo_Instrucao C with(nolock) on E.Tipo=C.Cd_Tp_Instrucao		
		where

			--E.Dt_Envio > getdate() -1 and 
			DATEADD(day,1,E.Dt_Envio) between  DATEADD(MONTH,-1,GETDATE()) and getdate()

			--E.dt_envio between '2023-01-16 00:00:000' and '2023-01-16 23:32:08.240' 
			and isnull(E.Verificado,0) = 0

			and right(E.num_proc,2) <> 'TT'
		order by
			E.Dt_Envio
	End	

	

	

GO
