SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_Courier_Del]
(
	@Num_Proc varchar(16),
	@Nome_Tp_Courier varchar(50),
	@Apelido varchar(20),
	@Num_Courier varchar(50)
)
as

Declare @ID_Tp_Courier int
Declare @Cd_Pes varchar(10)

Set @ID_Tp_Courier = (Select ID_Tp_Courier from Tipo_Courier where Nome_Tp_Courier = @Nome_Tp_Courier)
Set @Cd_Pes = (Select Cd_Pes from Pessoa where Apelido =  @Apelido)

delete Courier_Processo where Num_Proc = @Num_Proc and ID_Tp_Courier = @ID_Tp_Courier and Cd_Pes = @Cd_Pes and @Num_Courier = Num_Courier 

						
						


GO
