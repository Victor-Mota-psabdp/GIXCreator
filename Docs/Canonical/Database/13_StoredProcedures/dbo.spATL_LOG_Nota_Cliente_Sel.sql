SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_LOG_Nota_Cliente_Sel]
(  
	@ID_Log				bigint,
	@Nota_Fiscal		VarChar(20),  
	@Cd_Cliente			VarChar(10),
	@Num_Proc			VarChar(16),
	@Tipo				CHAR(1)  
)  
AS 

--sp_help LOG_Nota_Cliente
IF @Tipo = 'A'   or @Tipo = 'B' 
	BEGIN  
		SELECT 
			NC.ID				[Log ID],
			NC.Dt_NF			[Log Date],
			NC.Num_Proc			[JOB],
			NC.Nota_Fiscal		[Nota_Fiscal],
			NC.CD_Cliente		[Client Code],
			P.APelido			[Client Name],
			NC.Tipo_Oper_NF		[Log Type Code],
			TL.Nome_Tp_Log_Oper	[Log Type Name],
			NC.Justifica			
		FROM LOG_Nota_Cliente NC with (NOLOCK)
			JOIN Pessoa P with (NOLOCK)	ON P.Cd_Pes	 = NC.Cd_Cliente
			left join Tipo_Log_Oper TL with (NOLOCK) ON TL.Cd_Tp_Log_Oper = NC.Tipo_Oper_NF
		Where
			NC.ID= @ID_Log	
	END  
  
IF @Tipo = 'C'  or @Tipo = 'D'  
	BEGIN 
		SELECT 
			NC.ID				[Log ID],
			NC.Dt_NF			[Log Date],
			NC.Num_Proc			[JOB],
			NC.Nota_Fiscal		[Nota_Fiscal],
			NC.CD_Cliente		[Client Code],
			P.APelido			[Client Name],
			NC.Tipo_Oper_NF		[Log Type Code],
			TL.Nome_Tp_Log_Oper	[Log Type Name],
			NC.Justifica			
		FROM LOG_Nota_Cliente NC with (NOLOCK)
			JOIN Pessoa P with (NOLOCK)	ON P.Cd_Pes	 = NC.Cd_Cliente
			left join Tipo_Log_Oper TL with (NOLOCK) ON TL.Cd_Tp_Log_Oper = NC.Tipo_Oper_NF
		Where			
			NC.Num_Proc= @Num_Proc and NC.Nota_Fiscal = @Nota_Fiscal
	END



  

GO
