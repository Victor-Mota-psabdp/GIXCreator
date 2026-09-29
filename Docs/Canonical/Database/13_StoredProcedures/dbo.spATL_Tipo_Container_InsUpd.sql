SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Tipo_Container
CREATE PROCEDURE [dbo].[spATL_Tipo_Container_InsUpd]
(
	@Cd_Tp_Cont char(3),
	@Nome_Tp_Cont varchar(30),
	@Cd_CC_Ofc char(2),
	@CD_Smart varchar(4),
	@Capacidade_M3 float,
	@Carrier_Code varchar(5)
)

AS

Begin Transaction

	If  exists (select Cd_Tp_Cont from Tipo_Container where Cd_Tp_Cont=@Cd_Tp_Cont)
		Begin
			Update
				Tipo_Container
			Set
				Nome_Tp_Cont=@Nome_Tp_Cont,
				Cd_CC_Ofc = @Cd_CC_Ofc,
				CD_Smart =@CD_Smart,
				Capacidade_M3=@Capacidade_M3,
				Carrier_Code = @Carrier_Code
			Where
				Cd_Tp_Cont=@Cd_Tp_Cont
		End
	Else
		Insert
			Tipo_Container(Cd_Tp_Cont,Nome_Tp_Cont,Cd_CC_Ofc,CD_Smart,Capacidade_M3,Carrier_Code)
		Values
			(@Cd_Tp_Cont,@Nome_Tp_Cont,@Cd_CC_Ofc,@CD_Smart,@Capacidade_M3,@Carrier_Code)
	

Commit Transaction





GO
