SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--inclui o tipo pra nao trazer duplicado o q ja esta salvo como original ou copia
--e o num_proc = '' pra nao trazer um sem nada q esta salvo no doc anexos

CREATE Procedure [dbo].[spFaturaDocs_Rel] --[spFaturaDocs_Rel] 'IMUPL201207037BR'
	@Fatura varchar(17)
AS
	select Left(FD.Fatura_PC,16) Num_Proc, Nome_DC,Tipo from Fatura_Docs FD with(nolock)
	join Tipo_Doc_Cliente TDC with(nolock) on TDC.ID_DC=FD.ID_DC
	where FD.Fatura_PC=@Fatura

UNION 
	select Num_Proc,Nome_DC,null Tipo from doc_anexos DA with(nolock)
	Join Tipo_Doc_Cliente TDC with(nolock) on TDC.ID_DC=DA.ID_DC
	Left Join Fatura_Docs FD with(nolock) on Left(FD.Fatura_PC,16)=DA.Num_Proc and FD.ID_DC=DA.ID_DC
	where num_proc=left(@Fatura,16)  and num_proc<> '' and tipo is null


GO
