using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Homework1
{
    public partial class Form1 : Form
    {

        SqlConnection dbConn;
        SqlDataAdapter daAgents, daPlayers;
        DataSet ds;
        BindingSource bsAgents, bsPlayers;
        SqlCommandBuilder cbPlayers;            // we need it for SqlDataAdapter Update command

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                daPlayers.Update(ds, "BasketballPlayer");
                MessageBox.Show("Changes were saved successfully!");
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message);
            }
        }

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dbConn = new SqlConnection("Data Source = DELLG5-5587-ADA; Initial Catalog = BasketballLeagueDB; Integrated Security = True;");

            ds = new DataSet();

            daAgents = new SqlDataAdapter("SELECT * FROM Agent", dbConn);
            daPlayers = new SqlDataAdapter("SELECT * FROM BasketballPlayer", dbConn);

            cbPlayers = new SqlCommandBuilder(daPlayers);

            daAgents.Fill(ds, "Agent");
            daPlayers.Fill(ds, "BasketballPlayer");

            DataRelation dr = new DataRelation("FK_Players_Agents", ds.Tables["Agent"].Columns["AgentID"], ds.Tables["BasketballPlayer"].Columns["AgentID"]);

            ds.Relations.Add(dr);

            bsAgents = new BindingSource();
            bsAgents.DataSource = ds;
            bsAgents.DataMember = "Agent";

            bsPlayers = new BindingSource();
            bsPlayers.DataSource = bsAgents;
            bsPlayers.DataMember = "FK_Players_Agents";

            dgvAgents.DataSource = bsAgents;
            dgvPlayers.DataSource = bsPlayers;
        }
    }
}
