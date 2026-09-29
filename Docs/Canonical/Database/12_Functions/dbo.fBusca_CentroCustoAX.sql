SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create		FUNCTION [dbo].[fBusca_CentroCustoAX]
(
@Processo	Varchar(16)
)
RETURNS Varchar(5)
AS  
Begin
Declare @CC varchar(5)
Declare @Grupo varchar(3)

Set @CC = ''
Set @Grupo=	(Select Grupo from vwCliente Cli
	join Pessoa_LLP PS on Cli.cd_cliente = PS.Cd_Pes
	join Grupo GP on PS.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
	where num_proc = @Processo)

IF @Grupo = 'OXT'
	begin
		Set @CC ='13012'
	End


IF @CC =''
	IF substring(@Processo,2,1) = 'A'
	begin
		Set @CC = '13005'
	End
	
IF @CC =''
	IF substring(@Processo,2,1) = 'M'
	begin
		Set @CC = '13006'
	End

return @CC
End


GO
