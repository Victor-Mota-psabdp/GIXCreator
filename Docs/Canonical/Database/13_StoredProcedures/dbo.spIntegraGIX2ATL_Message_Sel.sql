SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spIntegraGIX2ATL_Message_Sel]
(
	@Num_Proc		varchar(16)
)

as

select                   
	'Automatic JOB integration - Update Fields'  [strAssunto],		 
	 'Automatic JOB integration - Change in fields :|'	[strCorpoMSG],	
	'br.sao.sistemas@bdpint.com;'+ US.email 	[strEmail],
	'br.sao.sistemas@bdpint.com'			[strResponderPara],	
	HOU.Num_Proc	[strJob]	
 FROM 
	vwClienteALLJOBS HOU
	left join Usuario US on US.cd_usuario = HOU.cd_usuario
 WHERE
	HOU.num_proc = @Num_Proc
 	

	
	
	

GO
