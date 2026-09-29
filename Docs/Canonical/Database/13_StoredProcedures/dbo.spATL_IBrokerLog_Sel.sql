SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerLog_Sel](
@Num_Proc varchar(16)
)

as

select ID_View [ID],Num_Proc [JOB],(case when Tipo = 'I' then 'Documento Criado' else case when Tipo = 'D' then 'Documento Excluido' else 'TXT Gerado' end end) [Status], U.Nome_Usuario [User],V.Dt_Insert [Date] from IBrokerView_Log V
join Usuario U on V.cd_usuario = U.Cd_Usuario
where Num_Proc = @Num_Proc
 
GO
