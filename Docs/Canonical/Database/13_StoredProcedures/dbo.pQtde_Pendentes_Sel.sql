SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pQtde_Pendentes_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pQtde_Pendentes_Sel
AS
	Declare @Master Int 
	Declare @House Int 
	Declare @Fatura Int 
	Declare @PreShip Int 
	
	Set @Master =IsNull( (Select Count(*) From Imp_MAWB Where IMAWB_Status = 'A' ),0)
	Set @House =IsNull( (Select Count(*) From Imp_HAWB Where IHAWB_Status = 'A' ),0)
	Set @PreShip = IsNull((Select Count(*) From Imp_PSHB Where IPSHB_Status = 'A'),0)
	Set @Fatura = IsNull((Select Count(*) From Imp_AINV Where IAINV_Status = 'A'),0)
	Set @Fatura = @Fatura + IsNull((Select Count(*) From Imp_ACDT Where IACDT_Status = 'A'),0)
	Set @Fatura = @Fatura + IsNull((Select Count(*) From Imp_MCDT Where IMCDT_Status = 'A'),0)
	Set @Fatura = @Fatura + IsNull((Select Count(*) From Imp_MINV Where IMINV_Status = 'A'),0)
	Set @Fatura = @Fatura + IsNull((Select Count(*) From Imp_NCDT Where INCDT_Status = 'A'),0)
	Set @Fatura = @Fatura + IsNull((Select Count(*) From Imp_NINV Where ININV_Status = 'A'),0)
	Select @Master as 'QtdMaster', @House as 'QtdHouse', @PreShip as 'QtdePreShip',  @Fatura as 'QtdFatura'



GO
