SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spValidaUsuario01]
(
	@ADUserName VARCHAR(40)
	,@ADDomain varchar(100)
	, @cd_nivel VARCHAR(3)
	, @NameSpace VARCHAR(150)
)
AS


/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date: 08/02/2021
. Application: Report XLS
. Developer: Alessandra Suzuki Mariano
. Request: Developer Request - Improvements to enable support N2 to deal with this matter / Security rules
-------------------------------------------------------------------------------------------------------------------------
EXECUTION EXECUTION
EXEC spValidaUsuario01 'midni','ALESUZUKI','TI','ReportXLSCadastro'

EXEC spValidaUsuario01 'amariano','BDPNT','TI','ReportXLSCadastro'



-------------------------------------------------------------------------------------------------------------------------

*/

SELECT  distinct 
	U.nome_usuario, U.cd_usuario, V.versao 
FROM 
	usuario U, versao_c# V
WHERE 
	 U.ck_ativo=1 
	 and U.ADUserName=@ADUserName
	 and U.ADDomain=@ADDomain
	 and U.cd_nivel=@cd_nivel
	 and V.namespace = @NameSpace 

	--Alessandra 08/02/2021 - Para que serve isso???
	insert versao_c# values(100,'ReportXLSCadastro',getdate(),'AO')



GO
