SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Log_FComex_Sel]
(       @Num_Proc   varchar(16),
	    @Dt_Ins     datetime,
	    @Dt_Fim     datetime,
		@Tipo       varchar(1)
)
as
/* Tipo de Processo 
   A todos processos gravados ate o momento  
   B processo unico 
   C todos por data    
   D so por causa de teste, os jobs são de numeracao diferentes na produção e no teste 
*/
if @Tipo ='A'
			BEGIN
			   select 
					[Num_Proc],
					[Cd_Usuario],
					[Dt_Ins],
					[Origem],
					[Message]
				from Log_FComex
				order by Num_Proc, Dt_Ins 
 		   END
Else
	if @Tipo ='B'
		BEGIN
			   select 
					[Num_Proc],
					[Cd_Usuario],
					[Dt_Ins],
					[Origem],
					[Message]
				from dbo.Log_FComex
				where Num_Proc = @Num_Proc 	
		END
Else
	if @Tipo ='C'
		BEGIN
				select 
					[Num_Proc],
					[Cd_Usuario],
					[Dt_Ins],
					[Origem],
					[Message]
				from dbo.Log_FComex
				where Dt_Ins >= @Dt_Ins
				and   Dt_Ins <=@Dt_Fim 
		END
Else
	if @Tipo ='D'
		BEGIN
			   select 
					l.[Num_Proc],
					l.[Cd_Usuario],
					l.[Dt_Ins],
					l.[Origem],
					l.[Message],
					u.[Cd_Usuario] [Code],
					u.[Nome_Usuario] [Name]
				from dbo.Log_FComex l 
				join atl_int.dbo.JSON_FComex_JobReferences_Line j
				on j.Num_Proc = l.Num_Proc 
				join Usuario u 
				on u.Cd_Usuario = l.Cd_Usuario
				where l.Num_Proc = @Num_Proc 	
		END


GO
