SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Site
CREATE PROCEDURE [dbo].[spATLDN_Site_InsUpd]
(
	@Cd_Site		char(1),
	@Nome_Site		varchar(30),
	@Aliq_Pis		decimal(18,2),
	@Aliq_Cofins	decimal(18,2),
	@Aliq_IRRF		decimal(18,2),
	@Aliq_CSLL		decimal(18,2),
	@Aliq_ISS		decimal(18,2),
	@Site_AX		varchar(30),
	@Status			bit
	
)

AS

Begin Transaction

	If  exists (select Cd_Site from Site where Cd_Site=@Cd_Site)
		Begin
			Update
				Site
			Set
				Nome_Site=@Nome_Site,
				Aliq_Pis=@Aliq_Pis,
				Aliq_Cofins=@Aliq_Cofins,
				Aliq_IRRF=@Aliq_IRRF,
				Aliq_CSLL=@Aliq_CSLL,
				Aliq_ISS=@Aliq_ISS,
				Site_AX=@Site_AX,			
				Status=@Status	
			Where
				Cd_Site=@Cd_Site
		End
	Else
		Begin
			Insert Site
				(Cd_Site,Nome_Site,Aliq_Pis,Aliq_Cofins,Aliq_IRRF,Aliq_CSLL,Aliq_ISS,Site_AX,Status)
			Values
				(@Cd_Site,@Nome_Site,@Aliq_Pis,@Aliq_Cofins,@Aliq_IRRF,@Aliq_CSLL,@Aliq_ISS,@Site_AX,@Status)
		End

Commit Transaction

GO
