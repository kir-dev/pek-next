
<p id="notice"><%= notice %></p>

<p>
  <strong>Neptun:</strong>
  <%= @user.neptun %>
</p>

<p>
  <strong>Email:</strong>
  <%= @user.email %>
</p>

<%= link_to 'Back', users_path %>
