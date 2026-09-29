SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Doc_Received_By_Email
--[spATL_Doc_Received_By_Email_Sel_Sel] '','complete','c'
CREATE procedure [dbo].[spATL_Doc_Received_By_Email_Sel]
(
	@ID					bigint,
	@From	varchar(200),
	@Subject varchar(200),
	@Doc_Extension		varchar(200),
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
			D.[ID],
			D.[Folder],
			D.[Item],
			D.[Doc_Name],
			D.[Doc_Extension],
			D.[Path],
			D.[Doc_Full_Name],
			D.[From],
			D.[Subject],
			D.[Received],
			D.[To],
			D.[Cc],
			D.[Bcc],
			D.[Dt_ins],
			D.[Dt_ATL]
		from 
			ATL_INT.dbo.Doc_Received_By_Email D with(nolock)
			
	End

--C	From and Doc Extension	1	LSAN	2023-05-18 13:22:19.460
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			D.[ID],
			D.[Folder],
			D.[Item],
			D.[Doc_Name],
			D.[Doc_Extension],
			D.[Path],
			D.[Doc_Full_Name],
			D.[From],
			D.[Subject],
			D.[Received],
			D.[To],
			D.[Cc],
			D.[Bcc],
			D.[Dt_ins],
			D.[Dt_ATL]
		from 
			ATL_INT.dbo.Doc_Received_By_Email D with(nolock)			
		where 
			d.[From] = @From		
			and d.doc_extension = @Doc_Extension 
			and d.dt_atl is null		
			order by 
				folder		
end

--E	Subject and Doc Extension	1	LSAN	2023-05-18 13:22:31.860
if @Tipo = 'E' or @Tipo = 'F'
	Begin
		select 
			D.[ID],
			D.[Folder],
			D.[Item],
			D.[Doc_Name],
			D.[Doc_Extension],
			D.[Path],
			D.[Doc_Full_Name],
			D.[From],
			D.[Subject],
			D.[Received],
			D.[To],
			D.[Cc],
			D.[Bcc],
			D.[Dt_ins],
			D.[Dt_ATL]
		from 
			ATL_INT.dbo.Doc_Received_By_Email D with(nolock)			
		where 
			d.Subject like '%' + @Subject + '%'
			and d.doc_extension = @Doc_Extension 
			and d.dt_atl is null
		order by 
			folder	
end

--N	From and Subject and Doc Ext	1	LSAN	2023-05-18 13:22:42.693
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			D.[ID],
			D.[Folder],
			D.[Item],
			D.[Doc_Name],
			D.[Doc_Extension],
			D.[Path],
			D.[Doc_Full_Name],
			D.[From],
			D.[Subject],
			D.[Received],
			D.[To],
			D.[Cc],
			D.[Bcc],
			D.[Dt_ins],
			D.[Dt_ATL]
		from 
			ATL_INT.dbo.Doc_Received_By_Email D with(nolock)			
		where 
			d.[From] = @From
			and d.Subject like '%' + @Subject + '%'		
			and d.doc_extension = @Doc_Extension 
			and d.dt_atl is null
		order by 
			folder
	
end

if @Tipo = 'I'--usada na tela do Integrated Received
	Begin
		select 
			D.[ID],
			D.[Folder],
			D.[Item],
			D.[Doc_Name],
			D.[Doc_Extension],
			D.[Path],
			D.[Doc_Full_Name],
			D.[From],
			D.[Subject],
			D.[Received],
			D.[To],
			D.[Cc],
			D.[Bcc],
			D.[Dt_ins],
			D.[Dt_ATL]
		from 
			ATL_INT.dbo.Doc_Received_By_Email D with(nolock)			
		Where
			D.Dt_Ins > getdate() -120	
end

GO
